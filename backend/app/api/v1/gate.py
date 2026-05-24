import json
import uuid
from datetime import datetime, date
from typing import Optional
from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func

from app.core.database import get_db
from app.core.redis_client import get_redis
from app.services.auth_service import get_current_user, require_roles
from app.models.user import User, Role
from app.models.student import Student, StudentStatus
from app.models.movement import MovementLog
from app.schemas.movement import (
    GateOTPRequest, GateOTPResponse, GuardConfirmRequest, GuardConfirmResponse,
    ManualEntryRequest, LiveStatusResponse, MovementLogResponse,
)
from app.services import gate_service

router = APIRouter(prefix="/gate", tags=["gate"])

CARETAKER_PLUS = (Role.CARETAKER, Role.ASST_WARDEN, Role.WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)


@router.post("/otp/generate", response_model=GateOTPResponse)
async def generate_otp(
    body: GateOTPRequest,
    db: AsyncSession = Depends(get_db),
    redis=Depends(get_redis),
    current_user: User = Depends(require_roles(Role.STUDENT)),
):
    return await gate_service.generate_student_otp(
        current_user,
        body.movement_type,
        body.destination,
        body.expected_return_iso,
        db,
        redis,
    )


@router.get("/otp/status")
async def otp_status(
    movement_type: str = Query(...),
    redis=Depends(get_redis),
    current_user: User = Depends(require_roles(Role.STUDENT)),
    db: AsyncSession = Depends(get_db),
):
    from app.models.student import Student
    from sqlalchemy import select
    result = await db.execute(select(Student).where(Student.user_id == current_user.id))
    student = result.scalar_one_or_none()
    if not student:
        return {"active": False}

    from app.core.otp import get_gate_otp_data
    data = await get_gate_otp_data(redis, str(student.id), movement_type)
    return {"active": data is not None}


@router.post("/confirm", response_model=GuardConfirmResponse)
async def confirm_passage(
    body: GuardConfirmRequest,
    db: AsyncSession = Depends(get_db),
    redis=Depends(get_redis),
    current_user: User = Depends(require_roles(Role.GUARD)),
):
    return await gate_service.confirm_gate_passage(
        body.student_id, body.otp, body.movement_type, current_user, db, redis
    )


@router.post("/manual-entry", response_model=GuardConfirmResponse)
async def manual_entry(
    body: ManualEntryRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.GUARD)),
):
    return await gate_service.manual_entry(
        body.room_number, body.movement_type, body.note, current_user, db
    )


@router.get("/live-requests")
async def live_requests(
    hostel_id: uuid.UUID = Query(...),
    db: AsyncSession = Depends(get_db),
    redis=Depends(get_redis),
    current_user: User = Depends(require_roles(Role.GUARD)),
):
    """
    Enriched live gate requests for the guard's hostel.
    Scans Redis gate:* keys, enriches with student/user data, filters by hostel.
    """
    keys = await redis.keys("gate:*")
    exit_requests = []
    entry_requests = []

    for key in keys:
        try:
            key_str = key.decode() if isinstance(key, bytes) else key
            parts = key_str.split(":")
            if len(parts) != 3:
                continue
            student_id_str, movement_type = parts[1], parts[2]

            data_raw = await redis.get(key)
            ttl = await redis.ttl(key)
            if not data_raw or ttl <= 0:
                continue

            data = json.loads(data_raw.decode() if isinstance(data_raw, bytes) else data_raw)

            # Fetch student and verify hostel
            try:
                student = await db.get(Student, uuid.UUID(student_id_str))
            except Exception:
                continue
            if not student or str(student.hostel_id) != str(hostel_id):
                continue

            user = await db.get(User, student.user_id)
            if not user:
                continue

            entry = {
                "student_id": student_id_str,
                "student_name": user.name or "Unknown",
                "room_number": student.room_number,
                "photo_url": None,
                "otp": data.get("otp", ""),
                "movement_type": movement_type,
                "destination": data.get("destination"),
                "expected_return": data.get("expected_return"),
                "expires_in_seconds": ttl,
                "requested_at": None,
            }

            if movement_type.upper() == "OUT":
                exit_requests.append(entry)
            else:
                entry_requests.append(entry)
        except Exception:
            continue

    # Count students currently OUT
    out_count_result = await db.execute(
        select(func.count(Student.id))
        .where(Student.hostel_id == hostel_id)
        .where(Student.current_status == StudentStatus.OUT)
    )
    total_out = out_count_result.scalar_one()

    # On-leave students (approved leave, still IN, expected to leave today)
    from app.models.leave import LeaveApplication, LeaveStatus
    today = date.today()
    leave_result = await db.execute(
        select(Student, User, LeaveApplication)
        .join(User, User.id == Student.user_id)
        .join(LeaveApplication, LeaveApplication.student_id == Student.id)
        .where(Student.hostel_id == hostel_id)
        .where(LeaveApplication.status == LeaveStatus.APPROVED)
        .where(LeaveApplication.from_date <= today)
        .where(LeaveApplication.to_date >= today)
        .where(Student.current_status == StudentStatus.IN)
    )
    on_leave = []
    for s, u, lv in leave_result.fetchall():
        on_leave.append({
            "student_id": str(s.id),
            "student_name": u.name or "Unknown",
            "room_number": s.room_number,
            "leave_id": str(lv.id),
        })

    return {
        "exit_requests": exit_requests,
        "entry_requests": entry_requests,
        "on_leave_students": on_leave,
        "total_out_count": total_out,
    }


@router.get("/shift-log")
async def shift_log(
    hostel_id: uuid.UUID = Query(...),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.GUARD)),
):
    """Today's movement log for the guard's shift."""
    today_start = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)

    result = await db.execute(
        select(MovementLog, Student, User)
        .join(Student, Student.id == MovementLog.student_id)
        .join(User, User.id == Student.user_id)
        .where(Student.hostel_id == hostel_id)
        .where(MovementLog.created_at >= today_start)
        .order_by(MovementLog.created_at.desc())
        .limit(200)
    )
    logs = []
    for log, student, user in result.fetchall():
        logs.append({
            "id": str(log.id),
            "student_name": user.name or "Unknown",
            "room_number": student.room_number,
            "movement_type": log.type.value if log.type else "OUT",
            "destination": log.destination,
            "is_flagged": bool(log.is_flagged),
            "is_overdue": bool(log.is_overdue),
            "created_at": log.created_at.isoformat() if log.created_at else None,
        })

    return {"logs": logs, "total": len(logs)}


@router.get("/live-out/{hostel_id}", response_model=LiveStatusResponse)
async def live_out(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await gate_service.get_current_out_students(hostel_id, db)


@router.get("/history", response_model=list[MovementLogResponse])
async def my_movement_history(
    limit: int = Query(50, le=200),
    page: int = Query(1, ge=1),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.STUDENT)),
):
    from app.models.student import Student
    from sqlalchemy import select
    result = await db.execute(select(Student).where(Student.user_id == current_user.id))
    student = result.scalar_one_or_none()
    if not student:
        return []
    return await gate_service.get_movement_history(student.id, db, limit)


@router.get("/history/{student_id}", response_model=list[MovementLogResponse])
async def movement_history(
    student_id: uuid.UUID,
    limit: int = Query(50, le=200),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return await gate_service.get_movement_history(student_id, db, limit)


@router.get("/flagged/{hostel_id}", response_model=list[MovementLogResponse])
async def flagged_entries(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await gate_service.get_flagged_entries(hostel_id, db)
