import uuid
import logging
from datetime import datetime, timezone
from typing import Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from fastapi import HTTPException

from app.models.student import Student, StudentStatus
from app.models.movement import MovementLog, MovementType
from app.models.user import User
from app.models.institution import Hostel
from app.schemas.movement import (
    GateOTPResponse, GuardConfirmResponse, MovementLogResponse, LiveStatusResponse,
)
from app.core.otp import generate_gate_otp, verify_gate_otp, get_gate_otp_data
from app.utils.audit import log_audit
from app.utils.notifications import send_fcm

logger = logging.getLogger(__name__)


async def generate_student_otp(
    student_user: User,
    movement_type: str,
    destination: Optional[str],
    expected_return_iso: Optional[str],
    db: AsyncSession,
    redis,
) -> GateOTPResponse:
    # Get student record
    result = await db.execute(select(Student).where(Student.user_id == student_user.id))
    student = result.scalar_one_or_none()
    if not student:
        raise HTTPException(status_code=404, detail="Student profile not found")

    # Validate movement direction
    if movement_type == "OUT" and student.current_status == StudentStatus.OUT:
        raise HTTPException(status_code=400, detail="Student is already OUT")
    if movement_type == "IN" and student.current_status == StudentStatus.IN:
        raise HTTPException(status_code=400, detail="Student is already IN")

    otp = await generate_gate_otp(
        redis,
        str(student.id),
        movement_type,
        destination=destination,
        expected_return=expected_return_iso,
    )

    return GateOTPResponse(
        otp=otp,
        expires_in_seconds=120,
        student_id=str(student.id),
        movement_type=movement_type,
    )


async def confirm_gate_passage(
    student_id: uuid.UUID,
    otp: str,
    movement_type: str,
    guard_user: User,
    db: AsyncSession,
    redis,
) -> GuardConfirmResponse:
    # Get OTP data before verifying (for destination/expected_return)
    otp_data = await get_gate_otp_data(redis, str(student_id), movement_type)
    if not otp_data:
        raise HTTPException(status_code=400, detail="OTP expired or not found")

    valid = await verify_gate_otp(redis, str(student_id), movement_type, otp)
    if not valid:
        raise HTTPException(status_code=400, detail="Invalid OTP")

    # Get student + user
    result = await db.execute(
        select(Student, User)
        .join(User, Student.user_id == User.id)
        .where(Student.id == student_id)
    )
    row = result.one_or_none()
    if not row:
        raise HTTPException(status_code=404, detail="Student not found")
    student, user = row.Student, row.User

    # Parse expected_return
    expected_return = None
    if otp_data.get("expected_return"):
        try:
            expected_return = datetime.fromisoformat(otp_data["expected_return"])
        except ValueError:
            pass

    # Check overdue (only on IN movement)
    is_overdue = False
    if movement_type == "IN" and expected_return:
        is_overdue = datetime.now(timezone.utc) > expected_return

    # Create movement log
    log = MovementLog(
        student_id=student.id,
        type=MovementType(movement_type),
        destination=otp_data.get("destination"),
        expected_return=expected_return,
        actual_return=datetime.now(timezone.utc) if movement_type == "IN" else None,
        guard_id=guard_user.id,
        is_overdue=is_overdue,
        is_flagged=False,
        created_at=datetime.now(timezone.utc),
    )
    db.add(log)

    # Update student status
    student.current_status = StudentStatus.OUT if movement_type == "OUT" else StudentStatus.IN
    await db.flush()

    # Notify guardian
    if student.guardian_user_id:
        direction = "left" if movement_type == "OUT" else "returned to"
        await send_fcm(
            [str(student.guardian_user_id)],
            title="DormConnect",
            body=f"{user.name} has {direction} the hostel.",
        )

    # Notify caretaker if overdue
    if is_overdue:
        await send_fcm(
            [str(guard_user.hostel_id)] if guard_user.hostel_id else [],
            title="Overdue Return",
            body=f"{user.name} (Room {student.room_number}) returned late.",
        )

    await log_audit(
        db,
        action=f"GATE_{movement_type}",
        entity_type="Student",
        entity_id=str(student.id),
        performed_by=guard_user.id,
        new_value={"movement_type": movement_type, "destination": otp_data.get("destination")},
    )

    await db.commit()

    return GuardConfirmResponse(
        success=True,
        student_name=user.name,
        room_number=student.room_number,
        movement_type=movement_type,
        timestamp=datetime.now(timezone.utc),
    )


async def manual_entry(
    room_number: str,
    movement_type: str,
    note: Optional[str],
    guard_user: User,
    db: AsyncSession,
) -> GuardConfirmResponse:
    # Find student by room in guard's hostel
    result = await db.execute(
        select(Student, User)
        .join(User, Student.user_id == User.id)
        .where(
            Student.room_number == room_number,
            Student.hostel_id == guard_user.hostel_id,
        )
        .limit(1)
    )
    row = result.one_or_none()
    if not row:
        raise HTTPException(status_code=404, detail=f"No active student found in room {room_number}")
    student, user = row.Student, row.User

    log = MovementLog(
        student_id=student.id,
        type=MovementType.MANUAL,
        note=note,
        guard_id=guard_user.id,
        is_flagged=True,
        is_overdue=False,
        created_at=datetime.now(timezone.utc),
    )
    db.add(log)

    student.current_status = StudentStatus.OUT if movement_type == "OUT" else StudentStatus.IN

    await log_audit(
        db,
        action="GATE_MANUAL",
        entity_type="Student",
        entity_id=str(student.id),
        performed_by=guard_user.id,
        new_value={"movement_type": movement_type, "note": note},
    )

    await db.commit()

    return GuardConfirmResponse(
        success=True,
        student_name=user.name,
        room_number=student.room_number,
        movement_type=movement_type,
        timestamp=datetime.now(timezone.utc),
    )


async def get_current_out_students(hostel_id: uuid.UUID, db: AsyncSession) -> LiveStatusResponse:
    result = await db.execute(
        select(MovementLog, Student, User)
        .join(Student, MovementLog.student_id == Student.id)
        .join(User, Student.user_id == User.id)
        .where(
            Student.hostel_id == hostel_id,
            Student.current_status == StudentStatus.OUT,
        )
        .order_by(MovementLog.created_at.desc())
    )
    rows = result.all()

    students_out = []
    for log, student, user in rows:
        students_out.append(MovementLogResponse(
            id=log.id,
            student_name=user.name,
            room_number=student.room_number,
            type=log.type.value,
            destination=log.destination,
            expected_return=log.expected_return,
            actual_return=log.actual_return,
            is_overdue=log.is_overdue,
            is_flagged=log.is_flagged,
            created_at=log.created_at,
        ))

    overdue_count = sum(1 for s in students_out if s.is_overdue)

    return LiveStatusResponse(
        students_out=students_out,
        total_out_count=len(students_out),
        overdue_count=overdue_count,
    )


async def get_movement_history(
    student_id: uuid.UUID, db: AsyncSession, limit: int = 50
) -> list[MovementLogResponse]:
    result = await db.execute(
        select(MovementLog, Student, User)
        .join(Student, MovementLog.student_id == Student.id)
        .join(User, Student.user_id == User.id)
        .where(MovementLog.student_id == student_id)
        .order_by(MovementLog.created_at.desc())
        .limit(limit)
    )
    rows = result.all()
    return [
        MovementLogResponse(
            id=log.id,
            student_name=user.name,
            room_number=student.room_number,
            type=log.type.value,
            destination=log.destination,
            expected_return=log.expected_return,
            actual_return=log.actual_return,
            is_overdue=log.is_overdue,
            is_flagged=log.is_flagged,
            created_at=log.created_at,
        )
        for log, student, user in rows
    ]


async def get_flagged_entries(hostel_id: uuid.UUID, db: AsyncSession) -> list[MovementLogResponse]:
    result = await db.execute(
        select(MovementLog, Student, User)
        .join(Student, MovementLog.student_id == Student.id)
        .join(User, Student.user_id == User.id)
        .where(
            Student.hostel_id == hostel_id,
            MovementLog.is_flagged == True,
        )
        .order_by(MovementLog.created_at.desc())
        .limit(100)
    )
    rows = result.all()
    return [
        MovementLogResponse(
            id=log.id,
            student_name=user.name,
            room_number=student.room_number,
            type=log.type.value,
            destination=log.destination,
            expected_return=log.expected_return,
            actual_return=log.actual_return,
            is_overdue=log.is_overdue,
            is_flagged=log.is_flagged,
            created_at=log.created_at,
        )
        for log, student, user in rows
    ]


async def check_overdue_returns(db: AsyncSession, redis) -> None:
    """Scheduler job: mark overdue OUT students and notify."""
    now = datetime.now(timezone.utc)

    result = await db.execute(
        select(MovementLog, Student, User)
        .join(Student, MovementLog.student_id == Student.id)
        .join(User, Student.user_id == User.id)
        .where(
            Student.current_status == StudentStatus.OUT,
            MovementLog.expected_return < now,
            MovementLog.is_overdue == False,
            MovementLog.actual_return == None,
        )
    )
    rows = result.all()

    for log, student, user in rows:
        log.is_overdue = True
        logger.warning(f"Overdue: {user.name} room {student.room_number}")

        await send_fcm(
            [],  # In real impl: fetch caretaker FCM tokens for hostel
            title="Overdue Return",
            body=f"{user.name} (Room {student.room_number}) has not returned.",
        )

    if rows:
        await db.commit()
