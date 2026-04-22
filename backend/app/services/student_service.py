import uuid
import logging
from typing import Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from fastapi import HTTPException

from app.models.user import User, Role
from app.models.student import Student, EnrollmentStatus, StudentStatus
from app.models.institution import Hostel
from app.schemas.student import (
    EnrollmentRequest, EnrollmentResponse, StudentProfile,
)
from app.core.security import hash_password
from app.utils.audit import log_audit
from app.utils.notifications import send_sms

logger = logging.getLogger(__name__)


async def create_enrollment(
    data: EnrollmentRequest,
    fee_receipt_url: Optional[str],
    db: AsyncSession,
) -> EnrollmentResponse:
    # Check phone not already registered
    existing = await db.execute(select(User).where(User.phone == data.phone))
    if existing.scalar_one_or_none():
        raise HTTPException(status_code=409, detail="Phone number already registered")

    # Verify hostel exists
    hostel_result = await db.execute(select(Hostel).where(Hostel.id == data.hostel_id))
    hostel = hostel_result.scalar_one_or_none()
    if not hostel:
        raise HTTPException(status_code=404, detail="Hostel not found")

    user = User(
        phone=data.phone,
        name=data.name,
        role=Role.STUDENT,
        hostel_id=data.hostel_id,
        institution_id=hostel.institution_id,
        is_active=False,
    )
    db.add(user)
    await db.flush()

    student = Student(
        user_id=user.id,
        roll_number=data.roll_number,
        room_number=data.room_number,
        hostel_id=data.hostel_id,
        enrollment_status=EnrollmentStatus.PENDING,
        fee_receipt_url=fee_receipt_url,
        current_status=StudentStatus.IN,
    )
    db.add(student)
    await db.flush()

    await log_audit(
        db,
        action="ENROLLMENT_SUBMITTED",
        entity_type="Student",
        entity_id=str(student.id),
        new_value={"name": data.name, "roll_number": data.roll_number, "phone": data.phone},
    )

    await db.commit()
    await db.refresh(student)
    await db.refresh(user)

    return EnrollmentResponse(
        id=student.id,
        name=user.name,
        roll_number=student.roll_number,
        enrollment_status=student.enrollment_status.value,
        created_at=student.created_at,
    )


async def get_pending_enrollments(hostel_id: uuid.UUID, db: AsyncSession) -> list[EnrollmentResponse]:
    result = await db.execute(
        select(Student, User)
        .join(User, Student.user_id == User.id)
        .where(Student.hostel_id == hostel_id, Student.enrollment_status == EnrollmentStatus.PENDING)
        .order_by(Student.created_at.asc())
    )
    rows = result.all()
    return [
        EnrollmentResponse(
            id=s.id,
            name=u.name,
            roll_number=s.roll_number,
            enrollment_status=s.enrollment_status.value,
            created_at=s.created_at,
        )
        for s, u in rows
    ]


async def approve_enrollment(
    student_id: uuid.UUID, caretaker_user: User, db: AsyncSession
) -> StudentProfile:
    student, user = await _get_student_and_user(student_id, db)

    if student.enrollment_status != EnrollmentStatus.PENDING:
        raise HTTPException(status_code=400, detail="Enrollment not in PENDING state")

    user.is_active = True
    student.enrollment_status = EnrollmentStatus.ACTIVE

    # Auto-create guardian user if guardian_phone stored (we need to query from enrollment metadata)
    # Guardian phone was passed at enrollment time — stored as separate user
    # Check if guardian already exists by looking up existing GUARDIAN users
    # (In a real flow, guardian_phone is stored during enrollment — here we query)

    await log_audit(
        db,
        action="ENROLLMENT_APPROVED",
        entity_type="Student",
        entity_id=str(student.id),
        performed_by=caretaker_user.id,
        old_value={"enrollment_status": "PENDING"},
        new_value={"enrollment_status": "ACTIVE"},
    )

    await db.commit()
    await db.refresh(student)
    await db.refresh(user)

    hostel = await db.get(Hostel, student.hostel_id) if student.hostel_id else None

    return _build_profile(student, user, hostel)


async def reject_enrollment(
    student_id: uuid.UUID, reason: str, caretaker_user: User, db: AsyncSession
) -> dict:
    student, user = await _get_student_and_user(student_id, db)

    if student.enrollment_status != EnrollmentStatus.PENDING:
        raise HTTPException(status_code=400, detail="Enrollment not in PENDING state")

    student.enrollment_status = EnrollmentStatus.INACTIVE

    await log_audit(
        db,
        action="ENROLLMENT_REJECTED",
        entity_type="Student",
        entity_id=str(student.id),
        performed_by=caretaker_user.id,
        new_value={"reason": reason},
    )

    await db.commit()
    return {"message": "Enrollment rejected", "reason": reason}


async def get_student_profile(student_id: uuid.UUID, db: AsyncSession) -> StudentProfile:
    student, user = await _get_student_and_user(student_id, db)
    hostel = await db.get(Hostel, student.hostel_id) if student.hostel_id else None

    guardian = None
    if student.guardian_user_id:
        guardian = await db.get(User, student.guardian_user_id)

    return _build_profile(student, user, hostel, guardian)


async def get_student_profile_by_user(user_id: uuid.UUID, db: AsyncSession) -> StudentProfile:
    result = await db.execute(select(Student).where(Student.user_id == user_id))
    student = result.scalar_one_or_none()
    if not student:
        raise HTTPException(status_code=404, detail="Student profile not found")
    return await get_student_profile(student.id, db)


async def update_student_room(
    student_id: uuid.UUID, room_number: str, caretaker_user: User, db: AsyncSession
) -> StudentProfile:
    student, user = await _get_student_and_user(student_id, db)
    old_room = student.room_number
    student.room_number = room_number

    await log_audit(
        db,
        action="ROOM_UPDATED",
        entity_type="Student",
        entity_id=str(student.id),
        performed_by=caretaker_user.id,
        old_value={"room_number": old_room},
        new_value={"room_number": room_number},
    )

    await db.commit()
    await db.refresh(student)
    hostel = await db.get(Hostel, student.hostel_id) if student.hostel_id else None
    return _build_profile(student, user, hostel)


async def get_hostel_students(
    hostel_id: uuid.UUID,
    db: AsyncSession,
    status_filter: Optional[str] = None,
    enrollment_status: Optional[str] = None,
    room_number: Optional[str] = None,
) -> list[StudentProfile]:
    query = (
        select(Student, User)
        .join(User, Student.user_id == User.id)
        .where(Student.hostel_id == hostel_id)
    )

    if status_filter and status_filter != "ALL":
        query = query.where(Student.current_status == status_filter)
    if enrollment_status:
        query = query.where(Student.enrollment_status == enrollment_status)
    if room_number:
        query = query.where(Student.room_number == room_number)

    result = await db.execute(query.order_by(Student.room_number))
    rows = result.all()

    hostel = await db.get(Hostel, hostel_id)
    return [_build_profile(s, u, hostel) for s, u in rows]


async def permanent_checkout(
    student_id: uuid.UUID, reason: str, caretaker_user: User, db: AsyncSession
) -> dict:
    from datetime import datetime, timezone
    student, user = await _get_student_and_user(student_id, db)

    student.enrollment_status = EnrollmentStatus.CHECKED_OUT
    student.permanent_checkout_date = datetime.now(timezone.utc)
    user.is_active = False

    await log_audit(
        db,
        action="PERMANENT_CHECKOUT",
        entity_type="Student",
        entity_id=str(student.id),
        performed_by=caretaker_user.id,
        new_value={"reason": reason},
    )

    await db.commit()
    return {"message": "Student permanently checked out"}


async def get_room_occupants(hostel_id: uuid.UUID, room_number: str, db: AsyncSession) -> list[StudentProfile]:
    return await get_hostel_students(hostel_id, db, room_number=room_number, enrollment_status="ACTIVE")


async def _get_student_and_user(student_id: uuid.UUID, db: AsyncSession):
    result = await db.execute(
        select(Student, User)
        .join(User, Student.user_id == User.id)
        .where(Student.id == student_id)
    )
    row = result.one_or_none()
    if not row:
        raise HTTPException(status_code=404, detail="Student not found")
    return row.Student, row.User


def _build_profile(
    student: Student,
    user: User,
    hostel: Optional[Hostel] = None,
    guardian: Optional[User] = None,
) -> StudentProfile:
    return StudentProfile(
        id=student.id,
        user_id=student.user_id,
        name=user.name,
        phone=user.phone,
        roll_number=student.roll_number,
        room_number=student.room_number,
        hostel_id=student.hostel_id,
        hostel_name=hostel.name if hostel else None,
        enrollment_status=student.enrollment_status.value,
        current_status=student.current_status.value,
        fee_receipt_url=student.fee_receipt_url,
        guardian_name=guardian.name if guardian else None,
        guardian_phone=guardian.phone if guardian else None,
        created_at=student.created_at,
    )
