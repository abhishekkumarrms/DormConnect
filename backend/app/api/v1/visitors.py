import uuid
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.services.auth_service import require_roles
from app.models.user import User, Role
from app.schemas.visitor import VisitorCreate, VisitorResponse
from app.services import visitor_service

router = APIRouter(prefix="/visitors", tags=["visitors"])

CARETAKER_PLUS = (Role.CARETAKER, Role.ASST_WARDEN, Role.WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)


@router.post("/", response_model=VisitorResponse)
async def request_visitor(
    body: VisitorCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.STUDENT)),
):
    return await visitor_service.request_visitor(current_user, body, db)


@router.get("/active/{hostel_id}", response_model=list[VisitorResponse])
async def active_visitors(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.GUARD, *CARETAKER_PLUS)),
):
    return await visitor_service.get_active_visitors(hostel_id, db)


@router.get("/", response_model=list[VisitorResponse])
async def list_visitors(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await visitor_service.get_visitor_history(hostel_id, db)


@router.post("/{visitor_id}/approve", response_model=VisitorResponse)
async def approve_visitor(
    visitor_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await visitor_service.approve_reject(visitor_id, True, current_user, db)


@router.post("/{visitor_id}/reject", response_model=VisitorResponse)
async def reject_visitor(
    visitor_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await visitor_service.approve_reject(visitor_id, False, current_user, db)


@router.post("/{visitor_id}/guard-entry", response_model=VisitorResponse)
async def guard_entry(
    visitor_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.GUARD)),
):
    return await visitor_service.guard_entry(visitor_id, current_user, db)


@router.post("/{visitor_id}/guard-exit", response_model=VisitorResponse)
async def guard_exit(
    visitor_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.GUARD)),
):
    return await visitor_service.guard_exit(visitor_id, current_user, db)
