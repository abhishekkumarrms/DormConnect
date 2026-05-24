import uuid
from typing import Optional
from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.services.auth_service import require_roles
from app.models.user import User, Role
from app.schemas.analytics import HostelStats, HostelHealthResponse, InstitutionOverview, StaffPerformance
from app.services import analytics_service

router = APIRouter(prefix="/analytics", tags=["analytics"])

SENIOR = (Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)
WARDEN_PLUS = (Role.WARDEN, Role.ASST_WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)
STAFF_ALL = (Role.CARETAKER, Role.WARDEN, Role.ASST_WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)


@router.get("/overview", response_model=InstitutionOverview)
async def institution_overview_query(
    institution_id: Optional[uuid.UUID] = Query(None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*WARDEN_PLUS)),
):
    iid = institution_id or current_user.institution_id
    if not iid:
        from fastapi import HTTPException
        raise HTTPException(status_code=400, detail="institution_id required")
    return await analytics_service.get_institution_overview(iid, db)


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


@router.get("/hostel-health/{hostel_id}", response_model=HostelHealthResponse)
async def hostel_health(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*STAFF_ALL)),
):
    """Flutter-compatible hostel health endpoint. Accessible to caretakers and above."""
    stats = await analytics_service.get_hostel_stats(hostel_id, db)
    pending_leaves = await analytics_service.get_pending_leave_count(hostel_id, db)
    pending_enrollments = await analytics_service.get_pending_enrollment_count(hostel_id, db)
    return HostelHealthResponse(
        hostel_id=str(hostel_id),
        hostel_name=stats.hostel_name,
        health_score=stats.health_score,
        total_students=stats.total_students,
        current_out=stats.currently_out,
        complaints_pending=stats.pending_complaints,
        maintenance_pending=stats.pending_maintenance,
        pending_leaves=pending_leaves,
        pending_enrollments=pending_enrollments,
    )


@router.get("/staff/{hostel_id}", response_model=list[StaffPerformance])
async def staff_performance(
    hostel_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*SENIOR)),
):
    return await analytics_service.get_staff_performance(hostel_id, db)
