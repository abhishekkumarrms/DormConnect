import uuid
import logging
from datetime import datetime, timezone
from typing import Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from fastapi import HTTPException

from app.models.complaint import Complaint, ComplaintUpdate, ComplaintStatus, ComplaintCategory
from app.models.student import Student
from app.models.user import User
from app.schemas.complaint import (
    ComplaintCreate, ComplaintResponse, UpdateEntry, ComplaintAction, ComplaintStats,
)
from app.utils.audit import log_audit
from app.utils.notifications import send_fcm

logger = logging.getLogger(__name__)

TRANSITIONS = {
    ComplaintStatus.SUBMITTED: {
        "ACCEPT": ComplaintStatus.ACCEPTED,
        "REJECT": ComplaintStatus.REJECTED,
    },
    ComplaintStatus.ACCEPTED: {
        "PROGRESS": ComplaintStatus.IN_PROGRESS,
        "REJECT": ComplaintStatus.REJECTED,
    },
    ComplaintStatus.IN_PROGRESS: {
        "RESOLVE": ComplaintStatus.RESOLVED,
        "ESCALATE": ComplaintStatus.ESCALATED,
    },
    ComplaintStatus.RESOLVED: {
        "REOPEN": ComplaintStatus.REOPENED,
    },
    ComplaintStatus.ESCALATED: {
        "RESOLVE": ComplaintStatus.RESOLVED,
        "ESCALATE": ComplaintStatus.ESCALATED,
    },
    ComplaintStatus.REOPENED: {
        "ACCEPT": ComplaintStatus.ACCEPTED,
        "REJECT": ComplaintStatus.REJECTED,
    },
}


async def create_complaint(
    student_user: User, data: ComplaintCreate, db: AsyncSession
) -> ComplaintResponse:
    result = await db.execute(select(Student).where(Student.user_id == student_user.id))
    student = result.scalar_one_or_none()
    if not student:
        raise HTTPException(status_code=404, detail="Student profile not found")

    try:
        category = ComplaintCategory(data.category)
    except ValueError:
        raise HTTPException(status_code=400, detail=f"Invalid category: {data.category}")

    complaint = Complaint(
        student_id=student.id,
        hostel_id=student.hostel_id,
        category=category,
        status=ComplaintStatus.SUBMITTED,
        description=data.description,
        photo_url=data.photo_url,
    )
    db.add(complaint)
    await db.commit()
    await db.refresh(complaint)

    return await get_complaint(complaint.id, db)


async def get_complaints(
    hostel_id: uuid.UUID,
    db: AsyncSession,
    status: Optional[str] = None,
    category: Optional[str] = None,
    student_id: Optional[uuid.UUID] = None,
    date_from: Optional[datetime] = None,
    date_to: Optional[datetime] = None,
) -> list[ComplaintResponse]:
    query = (
        select(Complaint)
        .where(Complaint.hostel_id == hostel_id)
        .order_by(Complaint.created_at.desc())
    )
    if status:
        query = query.where(Complaint.status == ComplaintStatus(status))
    if category:
        query = query.where(Complaint.category == ComplaintCategory(category))
    if student_id:
        query = query.where(Complaint.student_id == student_id)
    if date_from:
        query = query.where(Complaint.created_at >= date_from)
    if date_to:
        query = query.where(Complaint.created_at <= date_to)

    result = await db.execute(query)
    complaints = result.scalars().all()
    return [await _build_response(c, db) for c in complaints]


async def get_complaint(complaint_id: uuid.UUID, db: AsyncSession) -> ComplaintResponse:
    result = await db.execute(select(Complaint).where(Complaint.id == complaint_id))
    complaint = result.scalar_one_or_none()
    if not complaint:
        raise HTTPException(status_code=404, detail="Complaint not found")
    return await _build_response(complaint, db)


async def perform_action(
    complaint_id: uuid.UUID,
    action_data: ComplaintAction,
    actor_user: User,
    db: AsyncSession,
) -> ComplaintResponse:
    result = await db.execute(select(Complaint).where(Complaint.id == complaint_id))
    complaint = result.scalar_one_or_none()
    if not complaint:
        raise HTTPException(status_code=404, detail="Complaint not found")

    action = action_data.action.upper()
    allowed = TRANSITIONS.get(complaint.status, {})
    if action not in allowed:
        raise HTTPException(
            status_code=400,
            detail=f"Action '{action}' not allowed from status '{complaint.status.value}'",
        )

    old_status = complaint.status
    new_status = allowed[action]

    complaint.status = new_status
    if action == "RESOLVE":
        complaint.resolution_note = action_data.note
    if action == "ESCALATE" and action_data.escalate_to_id:
        complaint.escalated_to = action_data.escalate_to_id
    if action_data.assigned_to_id:
        complaint.assigned_to = action_data.assigned_to_id

    update_entry = ComplaintUpdate(
        complaint_id=complaint.id,
        updated_by=actor_user.id,
        old_status=old_status,
        new_status=new_status,
        note=action_data.note,
        created_at=datetime.now(timezone.utc),
    )
    db.add(update_entry)

    await log_audit(
        db,
        action=f"COMPLAINT_{action}",
        entity_type="Complaint",
        entity_id=str(complaint.id),
        performed_by=actor_user.id,
        old_value={"status": old_status.value},
        new_value={"status": new_status.value, "note": action_data.note},
    )

    await db.commit()
    await db.refresh(complaint)

    return await _build_response(complaint, db)


async def get_complaint_stats(hostel_id: uuid.UUID, db: AsyncSession) -> ComplaintStats:
    result = await db.execute(
        select(Complaint.status, Complaint.category, func.count())
        .where(Complaint.hostel_id == hostel_id)
        .group_by(Complaint.status, Complaint.category)
    )
    rows = result.all()

    status_counts = {}
    category_counts = {}
    total = 0

    for status, category, count in rows:
        status_counts[status.value] = status_counts.get(status.value, 0) + count
        category_counts[category.value] = category_counts.get(category.value, 0) + count
        total += count

    return ComplaintStats(
        total=total,
        pending=status_counts.get("SUBMITTED", 0),
        accepted=status_counts.get("ACCEPTED", 0),
        in_progress=status_counts.get("IN_PROGRESS", 0),
        resolved=status_counts.get("RESOLVED", 0),
        rejected=status_counts.get("REJECTED", 0),
        escalated=status_counts.get("ESCALATED", 0),
        by_category=category_counts,
    )


async def _build_response(complaint: Complaint, db: AsyncSession) -> ComplaintResponse:
    student_name = None
    room_number = None
    if complaint.student_id:
        row = await db.execute(
            select(Student, User)
            .join(User, Student.user_id == User.id)
            .where(Student.id == complaint.student_id)
        )
        sr = row.one_or_none()
        if sr:
            student_name = sr.User.name
            room_number = sr.Student.room_number

    assigned_name = None
    if complaint.assigned_to:
        u = await db.get(User, complaint.assigned_to)
        if u:
            assigned_name = u.name

    updates_result = await db.execute(
        select(ComplaintUpdate, User)
        .join(User, ComplaintUpdate.updated_by == User.id)
        .where(ComplaintUpdate.complaint_id == complaint.id)
        .order_by(ComplaintUpdate.created_at.asc())
    )
    updates = [
        UpdateEntry(
            updated_by_name=u.name,
            old_status=cu.old_status.value,
            new_status=cu.new_status.value,
            note=cu.note,
            created_at=cu.created_at,
        )
        for cu, u in updates_result.all()
    ]

    return ComplaintResponse(
        id=complaint.id,
        student_name=student_name,
        room_number=room_number,
        category=complaint.category.value,
        status=complaint.status.value,
        description=complaint.description,
        photo_url=complaint.photo_url,
        assigned_to_name=assigned_name,
        updates=updates,
        created_at=complaint.created_at,
        updated_at=complaint.updated_at,
    )
