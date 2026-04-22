import uuid
from typing import Optional
from fastapi import APIRouter, Depends, UploadFile, File, Form, Query, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.services.auth_service import get_current_user, require_roles
from app.models.user import User, Role
from app.schemas.student import (
    EnrollmentResponse, StudentProfile,
    ProfileUpdateRequest, RejectEnrollmentRequest, PermanentCheckoutRequest,
)
from app.services import student_service

router = APIRouter(prefix="/students", tags=["students"])

CARETAKER_PLUS = (Role.CARETAKER, Role.ASST_WARDEN, Role.WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)
WARDEN_PLUS = (Role.WARDEN, Role.ASST_WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)


@router.post("/enroll", response_model=EnrollmentResponse)
async def enroll_student(
    name: str = Form(...),
    phone: str = Form(...),
    roll_number: str = Form(...),
    hostel_id: uuid.UUID = Form(...),
    room_number: str = Form(...),
    guardian_name: str = Form(...),
    guardian_phone: str = Form(...),
    guardian_relation: str = Form(...),
    fee_receipt: Optional[UploadFile] = File(None),
    db: AsyncSession = Depends(get_db),
):
    fee_receipt_url = None
    if fee_receipt:
        try:
            import cloudinary.uploader
            content = await fee_receipt.read()
            result = cloudinary.uploader.upload(
                content,
                folder="dormconnect/fee_receipts",
                resource_type="auto",
            )
            fee_receipt_url = result.get("secure_url")
        except Exception:
            pass  # Proceed without receipt URL in dev

    from app.schemas.student import EnrollmentRequest
    data = EnrollmentRequest(
        name=name,
        phone=phone,
        roll_number=roll_number,
        hostel_id=hostel_id,
        room_number=room_number,
        guardian_name=guardian_name,
        guardian_phone=guardian_phone,
        guardian_relation=guardian_relation,
    )
    return await student_service.create_enrollment(data, fee_receipt_url, db)


@router.get("/pending-enrollments", response_model=list[EnrollmentResponse])
async def pending_enrollments(
    hostel_id: uuid.UUID = Query(...),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await student_service.get_pending_enrollments(hostel_id, db)


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


@router.get("/me", response_model=StudentProfile)
async def my_profile(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.STUDENT)),
):
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
