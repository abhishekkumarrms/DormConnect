import uuid
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.services.auth_service import require_roles
from app.models.user import User, Role
from app.schemas.analytics import HostelStats, InstitutionOverview, StaffPerformance
from app.services import analytics_service

router = APIRouter(prefix="/analytics", tags=["analytics"])

SENIOR = (Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)
WARDEN_PLUS = (Role.WARDEN, Role.ASST_WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)


@router.get("/institution/{institution_id}", response_model=InstitutionOverview)
async def institution_overview(
    institution_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*SENIOR)),
):
    return await analytics_service.get_institution_overview(institution_id, db)


@router.get("/hostel/{hostel_id}", response_model=HostelStats)
async def hostel_stats(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*WARDEN_PLUS)),
):
    return await analytics_service.get_hostel_stats(hostel_id, db)


@router.get("/health-score/{hostel_id}")
async def health_score(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*WARDEN_PLUS)),
):
    score = await analytics_service.get_hostel_health_score(hostel_id, db)
    return {"hostel_id": str(hostel_id), "health_score": score}


@router.get("/staff/{hostel_id}", response_model=list[StaffPerformance])
async def staff_performance(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*SENIOR)),
):
    return await analytics_service.get_staff_performance(hostel_id, db)
