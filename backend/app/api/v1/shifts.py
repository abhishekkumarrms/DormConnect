import uuid
from typing import Optional
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.services.auth_service import require_roles
from app.models.user import User, Role
from app.schemas.shift import ShiftAssign, ShiftHandover, ShiftResponse
from app.services import shift_service

router = APIRouter(prefix="/shifts", tags=["shifts"])

CARETAKER_PLUS = (Role.CARETAKER, Role.ASST_WARDEN, Role.WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)
SENIOR = (Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)


@router.post("/assign", response_model=ShiftResponse)
async def assign_shift(
    body: ShiftAssign,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*SENIOR)),
):
    return await shift_service.assign_shift(body, current_user, db)


@router.post("/{shift_id}/handover", response_model=ShiftResponse)
async def submit_handover(
    shift_id: uuid.UUID,
    body: ShiftHandover,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.CARETAKER)),
):
    return await shift_service.submit_handover(shift_id, body.note, current_user, db)


@router.get("/current/{hostel_id}", response_model=Optional[ShiftResponse])
async def current_shift(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await shift_service.get_current_shift(hostel_id, db)


@router.get("/handover/{hostel_id}", response_model=list[ShiftResponse])
async def handover_notes(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await shift_service.get_handover_notes(hostel_id, db)
