import uuid
from typing import Optional
from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.core.redis_client import get_redis
from app.services.auth_service import get_current_user, require_roles
from app.models.user import User, Role
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
    redis=Depends(get_redis),
    current_user: User = Depends(require_roles(Role.GUARD)),
):
    # Return pending (unconfirmed) OTP requests — scan Redis gate:* keys
    keys = await redis.keys("gate:*")
    import json
    requests = []
    for key in keys:
        data_raw = await redis.get(key)
        if data_raw:
            parts = key.split(":")
            if len(parts) == 3:
                requests.append({
                    "student_id": parts[1],
                    "movement_type": parts[2],
                    **json.loads(data_raw),
                })
    return {"pending_requests": requests, "count": len(requests)}


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
