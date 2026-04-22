import uuid
from typing import Optional
from datetime import date, time, datetime
from pydantic import BaseModel


class ShiftAssign(BaseModel):
    caretaker_id: uuid.UUID
    hostel_id: uuid.UUID
    shift_type: str  # MORNING, EVENING, NIGHT
    date: date
    start_time: Optional[time] = None
    end_time: Optional[time] = None


class ShiftHandover(BaseModel):
    note: str


class ShiftResponse(BaseModel):
    id: uuid.UUID
    caretaker_name: Optional[str] = None
    hostel_id: uuid.UUID
    shift_type: str
    date: date
    start_time: Optional[time] = None
    end_time: Optional[time] = None
    handover_note: Optional[str] = None
    created_at: datetime

    model_config = {"from_attributes": True}
