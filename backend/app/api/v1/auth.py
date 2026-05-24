from fastapi import APIRouter, Depends, Header, Request
from typing import Optional
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.core.redis_client import get_redis
from app.schemas.auth import (
    PhoneOTPRequest, VerifyOTPRequest, EmailLoginRequest,
    PINLoginRequest, TokenResponse, RefreshRequest,
)
from app.services.auth_service import (
    send_sms_otp, login_student_guardian, login_staff_email,
    login_guard_pin, refresh_tokens, get_current_user, _use_demo_otp,
)
from app.core.config import settings
from app.models.user import User

router = APIRouter(prefix="/auth", tags=["auth"])


@router.get("/debug-info")
async def debug_info(redis=Depends(get_redis)):
    """Only available when SMS is not configured — shows env and Redis health."""
    if not _use_demo_otp():
        return {"demo_mode": False}
    try:
        await redis.ping()
        redis_ok = True
    except Exception as e:
        redis_ok = False
    return {
        "demo_mode": True,
        "environment": settings.ENVIRONMENT,
        "sms_api_key_set": bool(settings.SMS_API_KEY),
        "redis_ok": redis_ok,
        "demo_otp": "123456",
    }


@router.get("/debug-otp/{phone}")
async def debug_otp(phone: str, redis=Depends(get_redis)):
    """Returns stored OTP for a phone — only available in demo mode."""
    if not _use_demo_otp():
        from fastapi import HTTPException
        raise HTTPException(status_code=403, detail="Not available in production with SMS configured")
    stored = await redis.get(f"sms_otp:{phone}")
    return {"phone": phone, "stored_otp": stored}


@router.post("/send-otp")
async def send_otp(
    body: PhoneOTPRequest,
    redis=Depends(get_redis),
):
    await send_sms_otp(body.phone, redis)
    return {"message": "OTP sent"}


@router.post("/verify-otp", response_model=TokenResponse)
async def verify_otp(
    body: VerifyOTPRequest,
    request: Request,
    db: AsyncSession = Depends(get_db),
    redis=Depends(get_redis),
):
    device_id = request.headers.get("X-Device-ID")
    return await login_student_guardian(body.phone, body.otp, device_id, db, redis)


@router.post("/staff-login", response_model=TokenResponse)
async def staff_login(
    body: EmailLoginRequest,
    request: Request,
    db: AsyncSession = Depends(get_db),
    redis=Depends(get_redis),
):
    device_id = request.headers.get("X-Device-ID") or body.device_id
    return await login_staff_email(body.email, body.password, device_id, db, redis)


@router.post("/guard-login", response_model=TokenResponse)
async def guard_login(
    body: PINLoginRequest,
    request: Request,
    db: AsyncSession = Depends(get_db),
    redis=Depends(get_redis),
):
    device_id = request.headers.get("X-Device-ID") or body.device_id
    return await login_guard_pin(body.phone, body.pin, device_id, db, redis)


@router.post("/refresh", response_model=TokenResponse)
async def refresh(
    body: RefreshRequest,
    db: AsyncSession = Depends(get_db),
    redis=Depends(get_redis),
):
    return await refresh_tokens(body.refresh_token, redis, db)


@router.get("/me")
async def me(current_user: User = Depends(get_current_user)):
    role_map = {
        "STUDENT": "student",
        "GUARDIAN": "guardian",
        "CHIEF_WARDEN": "chiefWarden",
        "ASST_CHIEF_WARDEN": "asstChiefWarden",
        "WARDEN": "warden",
        "ASST_WARDEN": "asstWarden",
        "CARETAKER": "caretaker",
        "GUARD": "guard",
    }
    return {
        "id": str(current_user.id),
        "name": current_user.name,
        "phone": current_user.phone,
        "email": current_user.email,
        "role": role_map.get(current_user.role.value, current_user.role.value),
        "hostelId": str(current_user.hostel_id) if current_user.hostel_id else None,
        "institutionId": str(current_user.institution_id) if current_user.institution_id else None,
        "isActive": current_user.is_active,
        "fcmToken": None,
        "createdAt": current_user.created_at.isoformat() if hasattr(current_user, 'created_at') and current_user.created_at else None,
    }


@router.post("/logout")
async def logout(
    current_user: User = Depends(get_current_user),
    redis=Depends(get_redis),
):
    await redis.delete(f"refresh:{current_user.id}")
    return {"message": "logged out"}
