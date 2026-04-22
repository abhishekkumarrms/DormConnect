import uuid
from typing import Optional
from datetime import datetime
from pydantic import BaseModel


class GateOTPRequest(BaseModel):
    movement_type: str  # OUT or IN
    destination: Optional[str] = None
    expected_return_iso: Optional[str] = None  # ISO datetime string


class GateOTPResponse(BaseModel):
    otp: str
    expires_in_seconds: int
    student_id: str
    movement_type: str


class GuardConfirmRequest(BaseModel):
    student_id: uuid.UUID
    otp: str
    movement_type: str


class GuardConfirmResponse(BaseModel):
    success: bool
    student_name: str
    room_number: str
    photo_url: Optional[str] = None
    movement_type: str
    timestamp: datetime


class MovementLogResponse(BaseModel):
    id: uuid.UUID
    student_name: Optional[str] = None
    room_number: Optional[str] = None
    type: str
    destination: Optional[str] = None
    expected_return: Optional[datetime] = None
    actual_return: Optional[datetime] = None
    is_overdue: bool
    is_flagged: bool
    created_at: datetime

    model_config = {"from_attributes": True}


class ManualEntryRequest(BaseModel):
    room_number: str
    movement_type: str  # OUT or IN
    note: Optional[str] = None


class LiveStatusResponse(BaseModel):
    students_out: list[MovementLogResponse]
    total_out_count: int
    overdue_count: int
