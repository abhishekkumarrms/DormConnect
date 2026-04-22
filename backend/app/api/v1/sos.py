import uuid
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.services.auth_service import require_roles
from app.models.user import User, Role
from app.schemas.sos import SOSResponse, SOSRespondRequest
from app.services import sos_service

router = APIRouter(prefix="/sos", tags=["sos"])

CARETAKER_PLUS = (Role.CARETAKER, Role.ASST_WARDEN, Role.WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)


@router.post("/trigger", response_model=SOSResponse)
async def trigger_sos(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.STUDENT)),
):
    return await sos_service.trigger_sos(current_user, db)


@router.post("/{sos_id}/respond", response_model=SOSResponse)
async def respond_sos(
    sos_id: uuid.UUID,
    body: SOSRespondRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await sos_service.respond_to_sos(sos_id, body.note or "", current_user, db)


@router.get("/history/{hostel_id}", response_model=list[SOSResponse])
async def sos_history(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await sos_service.get_sos_history(hostel_id, db)
