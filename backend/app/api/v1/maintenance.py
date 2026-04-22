import uuid
from typing import Optional
from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.services.auth_service import get_current_user, require_roles
from app.models.user import User, Role
from app.schemas.maintenance import MaintenanceCreate, MaintenanceResponse, MaintenanceAction, MaintenanceStats
from app.services import maintenance_service

router = APIRouter(prefix="/maintenance", tags=["maintenance"])

CARETAKER_PLUS = (Role.CARETAKER, Role.ASST_WARDEN, Role.WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)
WARDEN_PLUS = (Role.WARDEN, Role.ASST_WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)


@router.post("/", response_model=MaintenanceResponse)
async def create_request(
    body: MaintenanceCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.STUDENT)),
):
    return await maintenance_service.create_request(current_user, body, db)


@router.get("/mine", response_model=list[MaintenanceResponse])
async def my_requests(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.STUDENT)),
):
    from sqlalchemy import select
    from app.models.student import Student
    result = await db.execute(select(Student).where(Student.user_id == current_user.id))
    student = result.scalar_one_or_none()
    if not student:
        return []
    return await maintenance_service.get_requests(student.hostel_id, db, student_id=student.id)


@router.get("/stats/{hostel_id}", response_model=MaintenanceStats)
async def maintenance_stats(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*WARDEN_PLUS)),
):
    return await maintenance_service.get_stats(hostel_id, db)


@router.get("/", response_model=list[MaintenanceResponse])
async def list_requests(
    hostel_id: uuid.UUID = Query(...),
    status: Optional[str] = Query(None),
    category: Optional[str] = Query(None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await maintenance_service.get_requests(hostel_id, db, status=status, category=category)


@router.get("/{request_id}", response_model=MaintenanceResponse)
async def get_request(
    request_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return await maintenance_service.get_request(request_id, db)


@router.post("/{request_id}/action", response_model=MaintenanceResponse)
async def maintenance_action(
    request_id: uuid.UUID,
    body: MaintenanceAction,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await maintenance_service.perform_action(request_id, body, current_user, db)
