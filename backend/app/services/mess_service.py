import uuid
import logging
from datetime import date, datetime, timezone
from typing import Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_
from fastapi import HTTPException

from app.models.mess import MessMenu, MessOff
from app.models.student import Student, EnrollmentStatus
from app.models.leave import LeaveApplication, LeaveStatus
from app.models.user import User
from app.schemas.mess import (
    MessMenuCreate, MessMenuResponse, MessCountResponse, MessOffCreate, MessOffResponse,
)

logger = logging.getLogger(__name__)


async def post_menu(
    hostel_id: uuid.UUID, data: MessMenuCreate, caretaker_user: User, db: AsyncSession
) -> MessMenuResponse:
    result = await db.execute(
        select(MessMenu).where(MessMenu.hostel_id == hostel_id, MessMenu.date == data.date)
    )
    existing = result.scalar_one_or_none()
    if existing:
        existing.breakfast = data.breakfast
        existing.lunch = data.lunch
        existing.snacks = data.snacks
        existing.dinner = data.dinner
        existing.posted_by = caretaker_user.id
        await db.commit()
        await db.refresh(existing)
        return await _build_menu_response(existing, db)

    menu = MessMenu(
        hostel_id=hostel_id,
        date=data.date,
        breakfast=data.breakfast,
        lunch=data.lunch,
        snacks=data.snacks,
        dinner=data.dinner,
        posted_by=caretaker_user.id,
    )
    db.add(menu)
    await db.commit()
    await db.refresh(menu)
    return await _build_menu_response(menu, db)


async def get_today_menu(hostel_id: uuid.UUID, db: AsyncSession, menu_date: Optional[date] = None) -> Optional[MessMenuResponse]:
    target_date = menu_date or date.today()
    result = await db.execute(
        select(MessMenu).where(MessMenu.hostel_id == hostel_id, MessMenu.date == target_date)
    )
    menu = result.scalar_one_or_none()
    if not menu:
        return None
    return await _build_menu_response(menu, db)


async def get_mess_count(hostel_id: uuid.UUID, count_date: date, db: AsyncSession) -> MessCountResponse:
    total_result = await db.execute(
        select(func.count(Student.id)).where(
            Student.hostel_id == hostel_id,
            Student.enrollment_status == EnrollmentStatus.ACTIVE,
        )
    )
    total_students = total_result.scalar_one()

    leave_result = await db.execute(
        select(func.count(LeaveApplication.id))
        .join(Student, LeaveApplication.student_id == Student.id)
        .where(
            Student.hostel_id == hostel_id,
            LeaveApplication.status == LeaveStatus.APPROVED,
            LeaveApplication.from_date <= count_date,
            LeaveApplication.to_date >= count_date,
        )
    )
    on_leave = leave_result.scalar_one()

    mess_off_result = await db.execute(
        select(func.count(MessOff.id))
        .join(Student, MessOff.student_id == Student.id)
        .where(
            Student.hostel_id == hostel_id,
            MessOff.is_approved == True,
            MessOff.from_date <= count_date,
            MessOff.to_date >= count_date,
        )
    )
    mess_off = mess_off_result.scalar_one()

    return MessCountResponse(
        hostel_id=hostel_id,
        date=count_date,
        total_students=total_students,
        on_leave=on_leave,
        mess_off=mess_off,
        expected_count=max(0, total_students - on_leave - mess_off),
    )


async def apply_mess_off(student_user: User, data: MessOffCreate, db: AsyncSession) -> MessOffResponse:
    result = await db.execute(select(Student).where(Student.user_id == student_user.id))
    student = result.scalar_one_or_none()
    if not student:
        raise HTTPException(status_code=404, detail="Student profile not found")

    mess_off = MessOff(
        student_id=student.id,
        hostel_id=student.hostel_id,
        from_date=data.from_date,
        to_date=data.to_date,
        reason=data.reason,
        is_approved=False,
    )
    db.add(mess_off)
    await db.commit()
    await db.refresh(mess_off)
    return await _build_off_response(mess_off, db)


async def approve_mess_off(mess_off_id: uuid.UUID, caretaker_user: User, db: AsyncSession) -> MessOffResponse:
    mess_off = await db.get(MessOff, mess_off_id)
    if not mess_off:
        raise HTTPException(status_code=404, detail="Mess off request not found")
    mess_off.is_approved = True
    mess_off.approved_by = caretaker_user.id
    await db.commit()
    await db.refresh(mess_off)
    return await _build_off_response(mess_off, db)


async def get_mess_offs(hostel_id: uuid.UUID, count_date: Optional[date], db: AsyncSession) -> list[MessOffResponse]:
    query = (
        select(MessOff)
        .join(Student, MessOff.student_id == Student.id)
        .where(Student.hostel_id == hostel_id)
        .order_by(MessOff.created_at.desc())
    )
    if count_date:
        query = query.where(MessOff.from_date <= count_date, MessOff.to_date >= count_date)
    result = await db.execute(query)
    offs = result.scalars().all()
    return [await _build_off_response(o, db) for o in offs]


async def _build_menu_response(menu: MessMenu, db: AsyncSession) -> MessMenuResponse:
    poster_name = None
    if menu.posted_by:
        u = await db.get(User, menu.posted_by)
        if u:
            poster_name = u.name
    return MessMenuResponse(
        id=menu.id,
        hostel_id=menu.hostel_id,
        date=menu.date,
        breakfast=menu.breakfast,
        lunch=menu.lunch,
        snacks=menu.snacks,
        dinner=menu.dinner,
        posted_by_name=poster_name,
        created_at=menu.created_at,
    )


async def _build_off_response(off: MessOff, db: AsyncSession) -> MessOffResponse:
    student_name = None
    if off.student_id:
        row = await db.execute(
            select(Student, User)
            .join(User, Student.user_id == User.id)
            .where(Student.id == off.student_id)
        )
        sr = row.one_or_none()
        if sr:
            student_name = sr.User.name
    return MessOffResponse(
        id=off.id,
        student_name=student_name,
        from_date=off.from_date,
        to_date=off.to_date,
        reason=off.reason,
        is_approved=off.is_approved,
        created_at=off.created_at,
    )


async def get_my_mess_offs(student_id: uuid.UUID, db: AsyncSession) -> list[MessOffResponse]:
    result = await db.execute(
        select(MessOff)
        .where(MessOff.student_id == student_id)
        .order_by(MessOff.created_at.desc())
    )
    offs = result.scalars().all()
    return [await _build_off_response(o, db) for o in offs]
