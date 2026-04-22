import uuid
from typing import Optional
from datetime import date, datetime
from pydantic import BaseModel


class MessMenuCreate(BaseModel):
    date: date
    breakfast: Optional[str] = None
    lunch: Optional[str] = None
    snacks: Optional[str] = None
    dinner: Optional[str] = None


class MessMenuResponse(BaseModel):
    id: uuid.UUID
    hostel_id: uuid.UUID
    date: date
    breakfast: Optional[str] = None
    lunch: Optional[str] = None
    snacks: Optional[str] = None
    dinner: Optional[str] = None
    posted_by_name: Optional[str] = None
    created_at: datetime

    model_config = {"from_attributes": True}


class MessCountResponse(BaseModel):
    hostel_id: uuid.UUID
    date: date
    total_students: int
    on_leave: int
    mess_off: int
    expected_count: int


class MessOffCreate(BaseModel):
    from_date: date
    to_date: date
    reason: Optional[str] = None


class MessOffResponse(BaseModel):
    id: uuid.UUID
    student_name: Optional[str] = None
    from_date: date
    to_date: date
    reason: Optional[str] = None
    is_approved: bool
    created_at: datetime

    model_config = {"from_attributes": True}
