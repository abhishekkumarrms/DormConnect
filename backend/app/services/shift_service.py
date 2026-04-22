import uuid
import logging
from datetime import date, datetime, timezone
from typing import Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from fastapi import HTTPException

from app.models.shift import Shift, ShiftType
from app.models.user import User
from app.schemas.shift import ShiftAssign, ShiftResponse

logger = logging.getLogger(__name__)


async def assign_shift(data: ShiftAssign, assigner_user: User, db: AsyncSession) -> ShiftResponse:
    try:
        shift_type = ShiftType(data.shift_type)
    except ValueError:
        raise HTTPException(status_code=400, detail=f"Invalid shift type: {data.shift_type}")

    caretaker = await db.get(User, data.caretaker_id)
    if not caretaker:
        raise HTTPException(status_code=404, detail="Caretaker not found")

    shift = Shift(
        caretaker_id=data.caretaker_id,
        hostel_id=data.hostel_id,
        shift_type=shift_type,
        date=data.date,
        start_time=data.start_time,
        end_time=data.end_time,
    )
    db.add(shift)
    await db.commit()
    await db.refresh(shift)
    return await _build_response(shift, db)


async def submit_handover(shift_id: uuid.UUID, note: str, caretaker_user: User, db: AsyncSession) -> ShiftResponse:
    shift = await db.get(Shift, shift_id)
    if not shift:
        raise HTTPException(status_code=404, detail="Shift not found")
    if shift.caretaker_id != caretaker_user.id:
        raise HTTPException(status_code=403, detail="Not your shift")

    shift.handover_note = note
    await db.commit()
    await db.refresh(shift)
    return await _build_response(shift, db)


async def get_current_shift(hostel_id: uuid.UUID, db: AsyncSession) -> Optional[ShiftResponse]:
    today = date.today()
    now_hour = datetime.now().hour

    if 6 <= now_hour < 14:
        current_type = ShiftType.MORNING
    elif 14 <= now_hour < 22:
        current_type = ShiftType.EVENING
    else:
        current_type = ShiftType.NIGHT

    result = await db.execute(
        select(Shift).where(
            Shift.hostel_id == hostel_id,
            Shift.date == today,
            Shift.shift_type == current_type,
        ).limit(1)
    )
    shift = result.scalar_one_or_none()
    if not shift:
        return None
    return await _build_response(shift, db)


async def get_handover_notes(hostel_id: uuid.UUID, db: AsyncSession) -> list[ShiftResponse]:
    result = await db.execute(
        select(Shift)
        .where(Shift.hostel_id == hostel_id, Shift.handover_note != None)
        .order_by(Shift.date.desc(), Shift.created_at.desc())
        .limit(10)
    )
    shifts = result.scalars().all()
    return [await _build_response(s, db) for s in shifts]


async def _build_response(shift: Shift, db: AsyncSession) -> ShiftResponse:
    caretaker_name = None
    if shift.caretaker_id:
        u = await db.get(User, shift.caretaker_id)
        if u:
            caretaker_name = u.name
    return ShiftResponse(
        id=shift.id,
        caretaker_name=caretaker_name,
        hostel_id=shift.hostel_id,
        shift_type=shift.shift_type.value,
        date=shift.date,
        start_time=shift.start_time,
        end_time=shift.end_time,
        handover_note=shift.handover_note,
        created_at=shift.created_at,
    )
