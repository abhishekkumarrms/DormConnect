import uuid
from typing import Optional
from datetime import datetime
from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.services.auth_service import get_current_user, require_roles
from app.models.user import User, Role
from app.schemas.complaint import ComplaintCreate, ComplaintResponse, ComplaintAction, ComplaintStats
from app.services import complaint_service

router = APIRouter(prefix="/complaints", tags=["complaints"])

CARETAKER_PLUS = (Role.CARETAKER, Role.ASST_WARDEN, Role.WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)
WARDEN_PLUS = (Role.WARDEN, Role.ASST_WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)


@router.post("/", response_model=ComplaintResponse)
async def create_complaint(
    body: ComplaintCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.STUDENT)),
):
    return await complaint_service.create_complaint(current_user, body, db)


@router.get("/mine", response_model=list[ComplaintResponse])
async def my_complaints(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.STUDENT)),
):
    from sqlalchemy import select
    from app.models.student import Student
    result = await db.execute(select(Student).where(Student.user_id == current_user.id))
    student = result.scalar_one_or_none()
    if not student:
        return []
    return await complaint_service.get_complaints(student.hostel_id, db, student_id=student.id)


@router.get("/stats/{hostel_id}", response_model=ComplaintStats)
async def complaint_stats(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*WARDEN_PLUS)),
):
    return await complaint_service.get_complaint_stats(hostel_id, db)


@router.get("/", response_model=list[ComplaintResponse])
async def list_complaints(
    hostel_id: uuid.UUID = Query(...),
    status: Optional[str] = Query(None),
    category: Optional[str] = Query(None),
    date_from: Optional[datetime] = Query(None),
    date_to: Optional[datetime] = Query(None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await complaint_service.get_complaints(hostel_id, db, status=status, category=category, date_from=date_from, date_to=date_to)


@router.get("/{complaint_id}", response_model=ComplaintResponse)
async def get_complaint(
    complaint_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return await complaint_service.get_complaint(complaint_id, db)


@router.post("/{complaint_id}/action", response_model=ComplaintResponse)
async def complaint_action(
    complaint_id: uuid.UUID,
    body: ComplaintAction,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await complaint_service.perform_action(complaint_id, body, current_user, db)
