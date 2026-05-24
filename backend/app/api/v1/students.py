import uuid
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.services.auth_service import get_current_user, require_roles
from app.models.user import User, Role
from app.schemas.student import (
    EnrollmentRequest, EnrollmentResponse, StudentProfile,
    PendingEnrollmentResponse, ProfileUpdateRequest,
    RejectEnrollmentRequest, PermanentCheckoutRequest, ReassignHostelRequest,
)
from app.services import student_service

router = APIRouter(prefix="/students", tags=["students"])

CARETAKER_PLUS = (Role.CARETAKER, Role.ASST_WARDEN, Role.WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)


@router.post("/enroll", response_model=EnrollmentResponse, status_code=201)
async def enroll_student(
    data: EnrollmentRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Requires enrollment-scope JWT. Phone is derived from the authenticated user."""
    if getattr(current_user, "__token_scope__", "full") != "enrollment":
        raise HTTPException(status_code=403, detail="Requires enrollment-scope token")
    return await student_service.create_enrollment(data, current_user, db)


@router.get("/pending-enrollments", response_model=list[PendingEnrollmentResponse])
async def pending_enrollments(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    """Auto-scoped to the staff member's assigned hostel."""
    if not current_user.hostel_id:
        raise HTTPException(status_code=400, detail="No hostel assigned to your account")
    return await student_service.get_pending_enrollments(current_user.hostel_id, db)


@router.post("/{student_id}/approve", response_model=StudentProfile)
async def approve_enrollment(
    student_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await student_service.approve_enrollment(student_id, current_user, db)


@router.post("/{student_id}/reject")
async def reject_enrollment(
    student_id: uuid.UUID,
    body: RejectEnrollmentRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await student_service.reject_enrollment(student_id, body.reason, current_user, db)


@router.patch("/{student_id}/reassign-hostel", response_model=StudentProfile)
async def reassign_hostel(
    student_id: uuid.UUID,
    body: ReassignHostelRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    """Move a pending enrollment to a different hostel."""
    return await student_service.reassign_hostel(student_id, body.hostel_id, current_user, db)


@router.get("/me", response_model=StudentProfile)
async def my_profile(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Accessible with both full and enrollment-scope tokens."""
    if current_user.role != Role.STUDENT:
        raise HTTPException(status_code=403, detail="Student accounts only")
    return await student_service.get_student_profile_by_user(current_user.id, db)


@router.get("/hostel/{hostel_id}", response_model=list[StudentProfile])
async def hostel_students(
    hostel_id: uuid.UUID,
    status: Optional[str] = Query(None),
    enrollment_status: Optional[str] = Query(None),
    room_number: Optional[str] = Query(None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await student_service.get_hostel_students(
        hostel_id, db,
        status_filter=status,
        enrollment_status=enrollment_status,
        room_number=room_number,
    )


@router.get("/room/{hostel_id}/{room}", response_model=list[StudentProfile])
async def room_occupants(
    hostel_id: uuid.UUID,
    room: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await student_service.get_room_occupants(hostel_id, room, db)


@router.get("/{student_id}", response_model=StudentProfile)
async def student_profile(
    student_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await student_service.get_student_profile(student_id, db)


@router.patch("/{student_id}/room", response_model=StudentProfile)
async def update_room(
    student_id: uuid.UUID,
    body: ProfileUpdateRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await student_service.update_student_room(student_id, body.room_number, current_user, db)


@router.post("/{student_id}/checkout")
async def permanent_checkout(
    student_id: uuid.UUID,
    body: PermanentCheckoutRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await student_service.permanent_checkout(student_id, body.reason, current_user, db)
