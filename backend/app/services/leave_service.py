import uuid
import logging
from datetime import date, datetime, timezone, timedelta
from typing import Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_
from fastapi import HTTPException

from app.models.leave import LeaveApplication, LeaveType, LeaveStatus
from app.models.student import Student
from app.models.user import User
from app.models.mess import MessOff
from app.schemas.leave import (
    LeaveCreate, LeaveResponse, LeaveAction, GuardianConfirmRequest, LeaveCalendarEntry,
)
from app.utils.audit import log_audit
from app.utils.notifications import send_fcm

logger = logging.getLogger(__name__)

TRANSITIONS = {
    LeaveStatus.SUBMITTED: {
        "REVIEW": LeaveStatus.UNDER_REVIEW,
        "APPROVE": LeaveStatus.APPROVED,
        "REJECT": LeaveStatus.REJECTED,
    },
    LeaveStatus.UNDER_REVIEW: {
        "CONTACT_GUARDIAN": LeaveStatus.GUARDIAN_CONTACTED,
        "APPROVE": LeaveStatus.APPROVED,
        "REJECT": LeaveStatus.REJECTED,
    },
    LeaveStatus.GUARDIAN_CONTACTED: {
        "APPROVE": LeaveStatus.APPROVED,
        "REJECT": LeaveStatus.REJECTED,
    },
}


async def create_leave(student_user: User, data: LeaveCreate, db: AsyncSession) -> LeaveResponse:
    result = await db.execute(select(Student).where(Student.user_id == student_user.id))
    student = result.scalar_one_or_none()
    if not student:
        raise HTTPException(status_code=404, detail="Student profile not found")

    if data.from_date > data.to_date:
        raise HTTPException(status_code=400, detail="from_date must be before to_date")

    try:
        leave_type = LeaveType(data.leave_type)
    except ValueError:
        raise HTTPException(status_code=400, detail=f"Invalid leave type: {data.leave_type}")

    leave = LeaveApplication(
        student_id=student.id,
        leave_type=leave_type,
        status=LeaveStatus.SUBMITTED,
        from_date=data.from_date,
        to_date=data.to_date,
        reason=data.reason,
        destination=data.destination,
    )
    db.add(leave)
    await db.commit()
    await db.refresh(leave)
    return await _build_response(leave, db)


async def get_leaves(
    hostel_id: uuid.UUID,
    db: AsyncSession,
    status: Optional[str] = None,
) -> list[LeaveResponse]:
    query = (
        select(LeaveApplication)
        .join(Student, LeaveApplication.student_id == Student.id)
        .where(Student.hostel_id == hostel_id)
        .order_by(LeaveApplication.created_at.desc())
    )
    if status:
        query = query.where(LeaveApplication.status == LeaveStatus(status))

    result = await db.execute(query)
    leaves = result.scalars().all()
    return [await _build_response(l, db) for l in leaves]


async def get_my_leaves(student_id: uuid.UUID, db: AsyncSession) -> list[LeaveResponse]:
    result = await db.execute(
        select(LeaveApplication)
        .where(LeaveApplication.student_id == student_id)
        .order_by(LeaveApplication.created_at.desc())
    )
    leaves = result.scalars().all()
    return [await _build_response(l, db) for l in leaves]


async def update_leave_status(
    leave_id: uuid.UUID, action_data: LeaveAction, actor_user: User, db: AsyncSession
) -> LeaveResponse:
    result = await db.execute(select(LeaveApplication).where(LeaveApplication.id == leave_id))
    leave = result.scalar_one_or_none()
    if not leave:
        raise HTTPException(status_code=404, detail="Leave not found")

    action = action_data.action.upper()
    allowed = TRANSITIONS.get(leave.status, {})
    if action not in allowed:
        raise HTTPException(
            status_code=400,
            detail=f"Action '{action}' not allowed from status '{leave.status.value}'",
        )

    leave.status = allowed[action]
    leave.caretaker_id = actor_user.id
    if action_data.note:
        leave.caretaker_note = action_data.note

    # On APPROVE: auto-create MessOff for leave dates
    if action == "APPROVE":
        mess_off = MessOff(
            student_id=leave.student_id,
            hostel_id=(await db.execute(
                select(Student.hostel_id).where(Student.id == leave.student_id)
            )).scalar_one(),
            from_date=leave.from_date,
            to_date=leave.to_date,
            reason=f"Leave approved: {leave.reason}",
            is_approved=True,
            approved_by=actor_user.id,
        )
        db.add(mess_off)

    await log_audit(
        db,
        action=f"LEAVE_{action}",
        entity_type="LeaveApplication",
        entity_id=str(leave.id),
        performed_by=actor_user.id,
        new_value={"status": leave.status.value, "note": action_data.note},
    )

    await db.commit()
    await db.refresh(leave)
    return await _build_response(leave, db)


async def guardian_confirm(
    leave_id: uuid.UUID,
    data: GuardianConfirmRequest,
    guardian_user: User,
    db: AsyncSession,
) -> LeaveResponse:
    result = await db.execute(select(LeaveApplication).where(LeaveApplication.id == leave_id))
    leave = result.scalar_one_or_none()
    if not leave:
        raise HTTPException(status_code=404, detail="Leave not found")

    leave.guardian_confirmed = data.confirmed
    leave.guardian_note = data.note

    await db.commit()
    await db.refresh(leave)
    return await _build_response(leave, db)


async def get_leave_calendar(
    hostel_id: uuid.UUID, month: int, year: int, db: AsyncSession
) -> list[LeaveCalendarEntry]:
    import calendar
    days_in_month = calendar.monthrange(year, month)[1]
    all_dates = [date(year, month, d) for d in range(1, days_in_month + 1)]

    result = await db.execute(
        select(LeaveApplication, Student, User)
        .join(Student, LeaveApplication.student_id == Student.id)
        .join(User, Student.user_id == User.id)
        .where(
            Student.hostel_id == hostel_id,
            LeaveApplication.status == LeaveStatus.APPROVED,
            LeaveApplication.from_date <= date(year, month, days_in_month),
            LeaveApplication.to_date >= date(year, month, 1),
        )
    )
    rows = result.all()

    calendar_entries = []
    for d in all_dates:
        absent = [u.name for leave, s, u in rows if leave.from_date <= d <= leave.to_date]
        calendar_entries.append(LeaveCalendarEntry(
            date=d,
            absent_students=absent,
            count=len(absent),
        ))

    return calendar_entries


async def _build_response(leave: LeaveApplication, db: AsyncSession) -> LeaveResponse:
    student_name = None
    room_number = None
    if leave.student_id:
        row = await db.execute(
            select(Student, User)
            .join(User, Student.user_id == User.id)
            .where(Student.id == leave.student_id)
        )
        sr = row.one_or_none()
        if sr:
            student_name = sr.User.name
            room_number = sr.Student.room_number

    return LeaveResponse(
        id=leave.id,
        student_name=student_name,
        room_number=room_number,
        leave_type=leave.leave_type.value,
        status=leave.status.value,
        from_date=leave.from_date,
        to_date=leave.to_date,
        reason=leave.reason,
        destination=leave.destination,
        caretaker_note=leave.caretaker_note,
        guardian_confirmed=leave.guardian_confirmed,
        guardian_note=leave.guardian_note,
        created_at=leave.created_at,
        updated_at=leave.updated_at,
    )
