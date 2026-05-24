import uuid
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, desc

from app.core.database import get_db
from app.models.user import User, Role
from app.models.student import Student
from app.models.institution import Hostel
from app.schemas.student import StudentProfile
from app.schemas.leave import LeaveResponse
from app.services.auth_service import require_roles
from app.services import leave_service

router = APIRouter(prefix="/guardian", tags=["guardian"])


async def _get_child(current_user: User, db: AsyncSession) -> Student:
    result = await db.execute(
        select(Student).where(Student.guardian_user_id == current_user.id)
    )
    student = result.scalar_one_or_none()
    if not student:
        raise HTTPException(status_code=404, detail="No student linked to this guardian account.")
    return student


@router.get("/profile")
async def guardian_profile(
    current_user: User = Depends(require_roles(Role.GUARDIAN)),
    db: AsyncSession = Depends(get_db),
):
    student = await _get_child(current_user, db)
    hostel_name = None
    if student.hostel_id:
        hostel = await db.get(Hostel, student.hostel_id)
        hostel_name = hostel.name if hostel else None

    return {
        "guardian_id": str(current_user.id),
        "guardian_name": current_user.name,
        "guardian_phone": current_user.phone,
        "child_student_id": str(student.id),
        "child_name": student.name,
        "child_room": student.room_number,
        "child_hostel_id": str(student.hostel_id) if student.hostel_id else None,
        "child_hostel_name": hostel_name,
        "child_current_status": student.current_status.value if student.current_status else "IN",
    }


@router.get("/child/student", response_model=StudentProfile)
async def child_student(
    current_user: User = Depends(require_roles(Role.GUARDIAN)),
    db: AsyncSession = Depends(get_db),
):
    student = await _get_child(current_user, db)
    hostel_name = None
    if student.hostel_id:
        hostel = await db.get(Hostel, student.hostel_id)
        hostel_name = hostel.name if hostel else None
    student.hostel_name = hostel_name
    return student


@router.get("/child/leaves", response_model=list[LeaveResponse])
async def child_leaves(
    current_user: User = Depends(require_roles(Role.GUARDIAN)),
    db: AsyncSession = Depends(get_db),
):
    student = await _get_child(current_user, db)
    return await leave_service.get_my_leaves(student.id, db)


@router.get("/child/staff")
async def child_hostel_staff(
    current_user: User = Depends(require_roles(Role.GUARDIAN)),
    db: AsyncSession = Depends(get_db),
):
    """Returns caretakers and warden for the child's hostel."""
    student = await _get_child(current_user, db)
    if not student.hostel_id:
        return []

    result = await db.execute(
        select(User).where(
            User.hostel_id == student.hostel_id,
            User.role.in_([Role.CARETAKER, Role.WARDEN, Role.ASST_WARDEN]),
            User.is_active == True,
        )
    )
    staff = result.scalars().all()
    return [
        {
            "id": str(s.id),
            "name": s.name,
            "phone": s.phone or "",
            "role": s.role.value,
        }
        for s in staff
    ]
