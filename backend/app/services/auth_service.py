import logging
from typing import Optional
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
import httpx
import redis.asyncio as aioredis

from app.core.config import settings
from app.core.security import (
    hash_password, verify_password, hash_pin, verify_pin,
    create_access_token, create_refresh_token, decode_token,
)
from app.core.otp import generate_otp, store_sms_otp, verify_sms_otp
from app.core.database import get_db
from app.core.redis_client import get_redis
from app.models.user import User, Role
from app.models.student import Student, EnrollmentStatus
from app.schemas.auth import TokenResponse

logger = logging.getLogger(__name__)
security = HTTPBearer()


DEMO_OTP = "123456"

def _use_demo_otp() -> bool:
    return settings.DEMO_OTP_ENABLED or settings.ENVIRONMENT == "development"

async def send_sms_otp(phone: str, redis: aioredis.Redis) -> bool:
    use_demo = _use_demo_otp()
    otp = DEMO_OTP if use_demo else generate_otp(6)
    await store_sms_otp(redis, phone, otp)

    if use_demo:
        logger.info(f"[DEMO OTP] Phone: {phone} | OTP: {otp}")
        return True

    try:
        async with httpx.AsyncClient() as client:
            resp = await client.post(
                "https://api.msg91.com/api/v5/otp",
                json={
                    "template_id": "dormconnect_otp",
                    "mobile": f"91{phone}",
                    "authkey": settings.SMS_API_KEY,
                    "otp": otp,
                },
                timeout=10,
            )
            return resp.status_code == 200
    except Exception as e:
        logger.error(f"SMS send failed: {e}")
        return False


async def login_student_guardian(
    phone: str, otp: str, device_id: Optional[str], db: AsyncSession, redis: aioredis.Redis
) -> TokenResponse:
    valid = await verify_sms_otp(redis, phone, otp)
    if not valid:
        raise HTTPException(status_code=400, detail="Invalid or expired OTP")

    result = await db.execute(select(User).where(User.phone == phone))
    user = result.scalar_one_or_none()

    if not user:
        # Auto-create user shell — they complete enrollment via form
        user = User(phone=phone, name="", role=Role.STUDENT, is_active=False)
        db.add(user)
        await db.flush()
        await db.commit()
        await db.refresh(user)
        token = create_access_token(
            data={"sub": str(user.id), "role": user.role.value},
            scope="enrollment",
        )
        return TokenResponse(
            access_token=token,
            refresh_token="",
            role=user.role.value,
            user_id=str(user.id),
            scope="enrollment",
            enrollment_state="REQUIRED",
        )

    if user.role not in (Role.STUDENT, Role.GUARDIAN):
        raise HTTPException(status_code=403, detail="Use staff login for staff accounts")

    # Check enrollment status for students
    if user.role == Role.STUDENT:
        student_result = await db.execute(
            select(Student).where(Student.user_id == user.id)
        )
        student = student_result.scalar_one_or_none()

        if not student or student.enrollment_status == EnrollmentStatus.PENDING:
            enrollment_state = "REQUIRED" if not student else "PENDING"
            token = create_access_token(
                data={"sub": str(user.id), "role": user.role.value},
                scope="enrollment",
            )
            return TokenResponse(
                access_token=token,
                refresh_token="",
                role=user.role.value,
                user_id=str(user.id),
                scope="enrollment",
                enrollment_state=enrollment_state,
            )

        if not user.is_active:
            raise HTTPException(
                status_code=403,
                detail="Account deactivated. Contact caretaker.",
            )

    # OTP already proves phone ownership — allow re-binding device_id on reinstall
    if device_id:
        user.device_id = device_id
        await db.commit()

    return await _issue_tokens(user, redis)


async def login_staff_email(
    email: str, password: str, device_id: Optional[str], db: AsyncSession, redis: aioredis.Redis
) -> TokenResponse:
    result = await db.execute(select(User).where(User.email == email))
    user = result.scalar_one_or_none()

    if not user or not user.password_hash:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    if not verify_password(password, user.password_hash):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    if not user.is_active:
        raise HTTPException(status_code=403, detail="Account deactivated")

    # Email+password proves identity — allow re-binding on reinstall
    if device_id:
        user.device_id = device_id
        await db.commit()

    return await _issue_tokens(user, redis)


async def login_guard_pin(
    phone: str, pin: str, device_id: Optional[str], db: AsyncSession, redis: aioredis.Redis
) -> TokenResponse:
    result = await db.execute(select(User).where(User.phone == phone, User.role == Role.GUARD))
    user = result.scalar_one_or_none()

    if not user or not user.pin_hash:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    if not verify_pin(pin, user.pin_hash):
        raise HTTPException(status_code=401, detail="Invalid PIN")
    if not user.is_active:
        raise HTTPException(status_code=403, detail="Account deactivated")

    # PIN proves identity — allow re-binding on reinstall
    if device_id:
        user.device_id = device_id
        await db.commit()

    return await _issue_tokens(user, redis)


async def refresh_tokens(refresh_token: str, redis: aioredis.Redis, db: AsyncSession) -> TokenResponse:
    payload = decode_token(refresh_token)
    if not payload or payload.get("type") != "refresh":
        raise HTTPException(status_code=401, detail="Invalid refresh token")

    user_id = payload.get("sub")
    stored = await redis.get(f"refresh:{user_id}")
    if not stored or stored != refresh_token:
        raise HTTPException(status_code=401, detail="Refresh token expired or revoked")

    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if not user or not user.is_active:
        raise HTTPException(status_code=401, detail="User not found or inactive")

    return await _issue_tokens(user, redis)


async def _issue_tokens(user: User, redis: aioredis.Redis) -> TokenResponse:
    data = {"sub": str(user.id), "role": user.role.value}
    access_token = create_access_token(data, scope="full")
    refresh_token = create_refresh_token(data)

    from datetime import timedelta
    from app.core.config import settings
    await redis.setex(
        f"refresh:{user.id}",
        settings.REFRESH_TOKEN_EXPIRE_DAYS * 86400,
        refresh_token,
    )

    return TokenResponse(
        access_token=access_token,
        refresh_token=refresh_token,
        role=user.role.value,
        user_id=str(user.id),
        scope="full",
    )


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: AsyncSession = Depends(get_db),
) -> User:
    token = credentials.credentials
    payload = decode_token(token)
    if not payload or payload.get("type") != "access":
        raise HTTPException(status_code=401, detail="Invalid or expired token")

    user_id = payload.get("sub")
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()

    if not user:
        raise HTTPException(status_code=401, detail="User not found")

    scope = payload.get("scope", "full")
    user.__token_scope__ = scope  # type: ignore[attr-defined]

    # Enrollment-scope tokens are for pending/inactive students — skip is_active check
    if scope != "enrollment" and not user.is_active:
        raise HTTPException(status_code=401, detail="User not found or inactive")

    return user


def require_roles(*roles: Role):
    async def role_checker(current_user: User = Depends(get_current_user)) -> User:
        if getattr(current_user, "__token_scope__", "full") == "enrollment":
            raise HTTPException(
                status_code=403,
                detail="Complete enrollment and await caretaker approval first.",
            )
        if current_user.role not in roles:
            raise HTTPException(
                status_code=403,
                detail=f"Access denied. Required roles: {[r.value for r in roles]}",
            )
        return current_user
    return role_checker
