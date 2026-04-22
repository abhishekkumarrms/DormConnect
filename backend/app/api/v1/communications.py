import uuid
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.services.auth_service import require_roles
from app.models.user import User, Role
from app.schemas.broadcast import BroadcastCreate, BroadcastResponse, NoticeCreate, NoticeUpdate, NoticeResponse
from app.services import broadcast_service

router = APIRouter(prefix="/comms", tags=["communications"])

CARETAKER_PLUS = (Role.CARETAKER, Role.ASST_WARDEN, Role.WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)
ALL_AUTH = (Role.STUDENT, Role.GUARDIAN, Role.CARETAKER, Role.ASST_WARDEN, Role.WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN, Role.GUARD)


@router.post("/broadcast", response_model=BroadcastResponse)
async def send_broadcast(
    body: BroadcastCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await broadcast_service.send_broadcast(current_user, body, db)


@router.get("/broadcasts/{hostel_id}", response_model=list[BroadcastResponse])
async def list_broadcasts(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*ALL_AUTH)),
):
    return await broadcast_service.get_broadcasts(hostel_id, db)


@router.post("/notices", response_model=NoticeResponse)
async def create_notice(
    body: NoticeCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await broadcast_service.create_notice(current_user, body, db)


@router.get("/notices/{hostel_id}", response_model=list[NoticeResponse])
async def list_notices(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*ALL_AUTH)),
):
    return await broadcast_service.get_notices(hostel_id, db)


@router.patch("/notices/{notice_id}", response_model=NoticeResponse)
async def update_notice(
    notice_id: uuid.UUID,
    body: NoticeUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await broadcast_service.update_notice(notice_id, body, current_user, db)


@router.delete("/notices/{notice_id}")
async def delete_notice(
    notice_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await broadcast_service.delete_notice(notice_id, current_user, db)
