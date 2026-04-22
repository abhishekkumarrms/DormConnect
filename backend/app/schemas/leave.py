import uuid
from typing import Optional
from datetime import date, datetime
from pydantic import BaseModel


class LeaveCreate(BaseModel):
    leave_type: str  # HOME, MEDICAL, PERSONAL, ACADEMIC
    from_date: date
    to_date: date
    reason: str
    destination: Optional[str] = None


class LeaveResponse(BaseModel):
    id: uuid.UUID
    student_name: Optional[str] = None
    room_number: Optional[str] = None
    leave_type: str
    status: str
    from_date: date
    to_date: date
    reason: str
    destination: Optional[str] = None
    caretaker_note: Optional[str] = None
    guardian_confirmed: bool
    guardian_note: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}


class LeaveAction(BaseModel):
    action: str  # REVIEW, CONTACT_GUARDIAN, APPROVE, REJECT
    note: Optional[str] = None


class GuardianConfirmRequest(BaseModel):
    confirmed: bool
    note: Optional[str] = None


class LeaveCalendarEntry(BaseModel):
    date: date
    absent_students: list[str]  # student names
    count: int
