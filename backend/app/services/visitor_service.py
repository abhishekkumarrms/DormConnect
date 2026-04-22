import uuid
import logging
from datetime import datetime, timezone
from typing import Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from fastapi import HTTPException

from app.models.visitor import Visitor, VisitorStatus
from app.models.student import Student
from app.models.user import User
from app.schemas.visitor import VisitorCreate, VisitorResponse
from app.utils.audit import log_audit

logger = logging.getLogger(__name__)


async def request_visitor(student_user: User, data: VisitorCreate, db: AsyncSession) -> VisitorResponse:
    result = await db.execute(select(Student).where(Student.user_id == student_user.id))
    student = result.scalar_one_or_none()
    if not student:
        raise HTTPException(status_code=404, detail="Student profile not found")

    visitor = Visitor(
        student_id=student.id,
        hostel_id=student.hostel_id,
        visitor_name=data.visitor_name,
        relation=data.relation,
        visitor_phone=data.visitor_phone,
        purpose=data.purpose,
        expected_at=data.expected_at,
        expected_duration_hours=data.expected_duration_hours,
        status=VisitorStatus.REQUESTED,
    )
    db.add(visitor)
    await db.commit()
    await db.refresh(visitor)
    return await _build_response(visitor, db)


async def approve_reject(
    visitor_id: uuid.UUID, approved: bool, caretaker_user: User, db: AsyncSession
) -> VisitorResponse:
    visitor = await db.get(Visitor, visitor_id)
    if not visitor:
        raise HTTPException(status_code=404, detail="Visitor request not found")

    visitor.status = VisitorStatus.APPROVED if approved else VisitorStatus.REJECTED
    visitor.approved_by = caretaker_user.id
    await db.commit()
    await db.refresh(visitor)
    return await _build_response(visitor, db)


async def guard_entry(visitor_id: uuid.UUID, guard_user: User, db: AsyncSession) -> VisitorResponse:
    visitor = await db.get(Visitor, visitor_id)
    if not visitor:
        raise HTTPException(status_code=404, detail="Visitor not found")
    if visitor.status != VisitorStatus.APPROVED:
        raise HTTPException(status_code=400, detail="Visitor not approved")

    visitor.status = VisitorStatus.INSIDE
    visitor.guard_entry_id = guard_user.id
    visitor.entry_at = datetime.now(timezone.utc)
    await db.commit()
    await db.refresh(visitor)
    return await _build_response(visitor, db)


async def guard_exit(visitor_id: uuid.UUID, guard_user: User, db: AsyncSession) -> VisitorResponse:
    visitor = await db.get(Visitor, visitor_id)
    if not visitor:
        raise HTTPException(status_code=404, detail="Visitor not found")
    if visitor.status != VisitorStatus.INSIDE:
        raise HTTPException(status_code=400, detail="Visitor not inside")

    visitor.status = VisitorStatus.EXITED
    visitor.exit_at = datetime.now(timezone.utc)
    await db.commit()
    await db.refresh(visitor)
    return await _build_response(visitor, db)


async def get_active_visitors(hostel_id: uuid.UUID, db: AsyncSession) -> list[VisitorResponse]:
    result = await db.execute(
        select(Visitor)
        .where(Visitor.hostel_id == hostel_id, Visitor.status == VisitorStatus.INSIDE)
        .order_by(Visitor.entry_at.desc())
    )
    visitors = result.scalars().all()
    return [await _build_response(v, db) for v in visitors]


async def get_visitor_history(hostel_id: uuid.UUID, db: AsyncSession, limit: int = 100) -> list[VisitorResponse]:
    result = await db.execute(
        select(Visitor)
        .where(Visitor.hostel_id == hostel_id)
        .order_by(Visitor.created_at.desc())
        .limit(limit)
    )
    visitors = result.scalars().all()
    return [await _build_response(v, db) for v in visitors]


async def _build_response(visitor: Visitor, db: AsyncSession) -> VisitorResponse:
    student_name = None
    if visitor.student_id:
        row = await db.execute(
            select(Student, User)
            .join(User, Student.user_id == User.id)
            .where(Student.id == visitor.student_id)
        )
        sr = row.one_or_none()
        if sr:
            student_name = sr.User.name

    approved_by_name = None
    if visitor.approved_by:
        u = await db.get(User, visitor.approved_by)
        if u:
            approved_by_name = u.name

    return VisitorResponse(
        id=visitor.id,
        student_name=student_name,
        visitor_name=visitor.visitor_name,
        relation=visitor.relation,
        visitor_phone=visitor.visitor_phone,
        purpose=visitor.purpose,
        expected_at=visitor.expected_at,
        expected_duration_hours=visitor.expected_duration_hours,
        status=visitor.status.value,
        approved_by_name=approved_by_name,
        entry_at=visitor.entry_at,
        exit_at=visitor.exit_at,
        created_at=visitor.created_at,
    )
