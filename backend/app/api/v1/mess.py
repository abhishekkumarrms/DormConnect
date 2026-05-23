import uuid
from typing import Optional
from datetime import date
from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.services.auth_service import require_roles
from app.models.user import User, Role
from app.schemas.mess import MessMenuCreate, MessMenuResponse, MessCountResponse, MessOffCreate, MessOffResponse
from app.services import mess_service

router = APIRouter(prefix="/mess", tags=["mess"])

CARETAKER_PLUS = (Role.CARETAKER, Role.ASST_WARDEN, Role.WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN)
ALL_AUTH = (Role.STUDENT, Role.GUARDIAN, Role.CARETAKER, Role.ASST_WARDEN, Role.WARDEN, Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN, Role.GUARD)


@router.post("/menu", response_model=MessMenuResponse)
async def post_menu(
    hostel_id: uuid.UUID,
    body: MessMenuCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await mess_service.post_menu(hostel_id, body, current_user, db)


@router.get("/menu", response_model=Optional[MessMenuResponse])
async def get_menu_by_query(
    hostel_id: Optional[uuid.UUID] = Query(None),
    menu_date: Optional[date] = Query(None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*ALL_AUTH)),
):
    hid = hostel_id or current_user.hostel_id
    if not hid:
        return None
    return await mess_service.get_today_menu(hid, db, menu_date)


@router.get("/menu/{hostel_id}", response_model=Optional[MessMenuResponse])
async def get_menu(
    hostel_id: uuid.UUID,
    menu_date: Optional[date] = Query(None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*ALL_AUTH)),
):
    return await mess_service.get_today_menu(hostel_id, db, menu_date)


@router.get("/count/{hostel_id}", response_model=MessCountResponse)
async def mess_count(
    hostel_id: uuid.UUID,
    count_date: Optional[date] = Query(None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await mess_service.get_mess_count(hostel_id, count_date or date.today(), db)


@router.post("/mess-off", response_model=MessOffResponse)
async def apply_mess_off(
    body: MessOffCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.STUDENT)),
):
    return await mess_service.apply_mess_off(current_user, body, db)


@router.get("/mess-off/my", response_model=list[MessOffResponse])
async def my_mess_offs(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(Role.STUDENT)),
):
    from app.models.student import Student
    from sqlalchemy import select
    result = await db.execute(select(Student).where(Student.user_id == current_user.id))
    student = result.scalar_one_or_none()
    if not student:
        return []
    return await mess_service.get_my_mess_offs(student.id, db)


@router.get("/mess-off/{hostel_id}", response_model=list[MessOffResponse])
async def list_mess_offs(
    hostel_id: uuid.UUID,
    mess_date: Optional[date] = Query(None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await mess_service.get_mess_offs(hostel_id, mess_date, db)


@router.post("/mess-off/{mess_off_id}/approve", response_model=MessOffResponse)
async def approve_mess_off(
    mess_off_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_roles(*CARETAKER_PLUS)),
):
    return await mess_service.approve_mess_off(mess_off_id, current_user, db)
