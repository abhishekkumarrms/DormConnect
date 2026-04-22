import uuid
import logging
from datetime import datetime, timezone
from typing import Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from fastapi import HTTPException

from app.models.maintenance import MaintenanceRequest, MaintenanceStatus, MaintenanceCategory
from app.models.student import Student
from app.models.user import User
from app.schemas.maintenance import (
    MaintenanceCreate, MaintenanceResponse, MaintenanceAction, MaintenanceStats,
)
from app.utils.audit import log_audit

logger = logging.getLogger(__name__)

TRANSITIONS = {
    MaintenanceStatus.SUBMITTED: {"ASSIGN": MaintenanceStatus.ASSIGNED},
    MaintenanceStatus.ASSIGNED: {
        "SCHEDULE": MaintenanceStatus.SCHEDULED,
        "PROGRESS": MaintenanceStatus.IN_PROGRESS,
    },
    MaintenanceStatus.SCHEDULED: {"PROGRESS": MaintenanceStatus.IN_PROGRESS},
    MaintenanceStatus.IN_PROGRESS: {"FIX": MaintenanceStatus.FIXED},
}


async def create_request(
    student_user: User, data: MaintenanceCreate, db: AsyncSession
) -> MaintenanceResponse:
    result = await db.execute(select(Student).where(Student.user_id == student_user.id))
    student = result.scalar_one_or_none()
    if not student:
        raise HTTPException(status_code=404, detail="Student profile not found")

    try:
        category = MaintenanceCategory(data.category)
    except ValueError:
        raise HTTPException(status_code=400, detail=f"Invalid category: {data.category}")

    req = MaintenanceRequest(
        student_id=student.id,
        hostel_id=student.hostel_id,
        category=category,
        status=MaintenanceStatus.SUBMITTED,
        description=data.description,
        room_number=data.room_number,
        photo_url=data.photo_url,
    )
    db.add(req)
    await db.commit()
    await db.refresh(req)

    return await _build_response(req, db)


async def get_requests(
    hostel_id: uuid.UUID,
    db: AsyncSession,
    status: Optional[str] = None,
    category: Optional[str] = None,
    student_id: Optional[uuid.UUID] = None,
) -> list[MaintenanceResponse]:
    query = (
        select(MaintenanceRequest)
        .where(MaintenanceRequest.hostel_id == hostel_id)
        .order_by(MaintenanceRequest.created_at.desc())
    )
    if status:
        query = query.where(MaintenanceRequest.status == MaintenanceStatus(status))
    if category:
        query = query.where(MaintenanceRequest.category == MaintenanceCategory(category))
    if student_id:
        query = query.where(MaintenanceRequest.student_id == student_id)

    result = await db.execute(query)
    reqs = result.scalars().all()
    return [await _build_response(r, db) for r in reqs]


async def get_request(request_id: uuid.UUID, db: AsyncSession) -> MaintenanceResponse:
    req = await db.get(MaintenanceRequest, request_id)
    if not req:
        raise HTTPException(status_code=404, detail="Maintenance request not found")
    return await _build_response(req, db)


async def perform_action(
    request_id: uuid.UUID,
    action_data: MaintenanceAction,
    actor_user: User,
    db: AsyncSession,
) -> MaintenanceResponse:
    req = await db.get(MaintenanceRequest, request_id)
    if not req:
        raise HTTPException(status_code=404, detail="Maintenance request not found")

    action = action_data.action.upper()
    allowed = TRANSITIONS.get(req.status, {})
    if action not in allowed:
        raise HTTPException(
            status_code=400,
            detail=f"Action '{action}' not allowed from status '{req.status.value}'",
        )

    old_status = req.status
    req.status = allowed[action]

    if action_data.assigned_to_id:
        req.assigned_to = action_data.assigned_to_id
    if action_data.scheduled_at:
        req.scheduled_at = action_data.scheduled_at
    if action == "FIX" and action_data.note:
        req.fixed_note = action_data.note

    await log_audit(
        db,
        action=f"MAINTENANCE_{action}",
        entity_type="MaintenanceRequest",
        entity_id=str(req.id),
        performed_by=actor_user.id,
        old_value={"status": old_status.value},
        new_value={"status": req.status.value},
    )

    await db.commit()
    await db.refresh(req)
    return await _build_response(req, db)


async def get_stats(hostel_id: uuid.UUID, db: AsyncSession) -> MaintenanceStats:
    result = await db.execute(
        select(MaintenanceRequest.status, MaintenanceRequest.category, func.count())
        .where(MaintenanceRequest.hostel_id == hostel_id)
        .group_by(MaintenanceRequest.status, MaintenanceRequest.category)
    )
    rows = result.all()

    status_counts = {}
    category_counts = {}
    total = 0

    for status, category, count in rows:
        status_counts[status.value] = status_counts.get(status.value, 0) + count
        category_counts[category.value] = category_counts.get(category.value, 0) + count
        total += count

    return MaintenanceStats(
        total=total,
        submitted=status_counts.get("SUBMITTED", 0),
        assigned=status_counts.get("ASSIGNED", 0),
        scheduled=status_counts.get("SCHEDULED", 0),
        in_progress=status_counts.get("IN_PROGRESS", 0),
        fixed=status_counts.get("FIXED", 0),
        by_category=category_counts,
    )


async def _build_response(req: MaintenanceRequest, db: AsyncSession) -> MaintenanceResponse:
    student_name = None
    if req.student_id:
        row = await db.execute(
            select(Student, User)
            .join(User, Student.user_id == User.id)
            .where(Student.id == req.student_id)
        )
        sr = row.one_or_none()
        if sr:
            student_name = sr.User.name

    assigned_name = None
    if req.assigned_to:
        u = await db.get(User, req.assigned_to)
        if u:
            assigned_name = u.name

    return MaintenanceResponse(
        id=req.id,
        student_name=student_name,
        room_number=req.room_number,
        category=req.category.value,
        status=req.status.value,
        description=req.description,
        photo_url=req.photo_url,
        assigned_to_name=assigned_name,
        scheduled_at=req.scheduled_at,
        fixed_note=req.fixed_note,
        created_at=req.created_at,
        updated_at=req.updated_at,
    )
