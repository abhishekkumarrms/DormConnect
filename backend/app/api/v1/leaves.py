import uuid
from typing import Optional
from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.services.auth_service import get_current_user, require_roles
from app.models.user import User, Role
from app.schemas.leave import LeaveCreate, LeaveResponse, LeaveAction, GuardianConfirmRequest, LeaveCalendarEntry
from app.services import leave_service

router = APIRouter(prefix="/leaves", tags=["leaves"])

CARETAKER_PLUS = (Role.CARETAKER, Role.ASST_WARDEN, Role.WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)


@router.post("/", response_model=LeaveResponse)
async def create_leave(
    body: LeaveCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.STUDENT)),
):
    return await leave_service.create_leave(current_user, body, db)


@router.get("/mine", response_model=list[LeaveResponse])
async def my_leaves(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.STUDENT)),
):
    from sqlalchemy import select
    from app.models.student import Student
    result = await db.execute(select(Student).where(Student.user_id == current_user.id))
    student = result.scalar_one_or_none()
    if not student:
        return []
    return await leave_service.get_my_leaves(student.id, db)


@router.get("/calendar/{hostel_id}", response_model=list[LeaveCalendarEntry])
async def leave_calendar(
    hostel_id: uuid.UUID,
    month: int = Query(..., ge=1, le=12),
    year: int = Query(..., ge=2020),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await leave_service.get_leave_calendar(hostel_id, month, year, db)


@router.get("/", response_model=list[LeaveResponse])
async def list_leaves(
    hostel_id: Optional[uuid.UUID] = Query(None),
    status: Optional[str] = Query(None),
    limit: Optional[int] = Query(None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    if current_user.role == Role.STUDENT:
        from sqlalchemy import select
        from app.models.student import Student
        result = await db.execute(select(Student).where(Student.user_id == current_user.id))
        student = result.scalar_one_or_none()
        if not student:
            return []
        rows = await leave_service.get_my_leaves(student.id, db)
        if status:
            rows = [r for r in rows if str(r.status.value if hasattr(r.status, 'value') else r.status).lower() == status.lower()]
        return rows[:limit] if limit else rows
    if not hostel_id:
        return []
    rows = await leave_service.get_leaves(hostel_id, db, status=status)
    return rows[:limit] if limit else rows


@router.post("/{leave_id}/action", response_model=LeaveResponse)
async def leave_action(
    leave_id: uuid.UUID,
    body: LeaveAction,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await leave_service.update_leave_status(leave_id, body, current_user, db)


@router.post("/{leave_id}/guardian-confirm", response_model=LeaveResponse)
async def guardian_confirm(
    leave_id: uuid.UUID,
    body: GuardianConfirmRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.GUARDIAN)),
):
    return await leave_service.guardian_confirm(leave_id, body, current_user, db)
