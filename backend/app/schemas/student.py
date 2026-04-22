import uuid
from typing import Optional
from datetime import datetime
from pydantic import BaseModel


class EnrollmentRequest(BaseModel):
    name: str
    phone: str
    roll_number: str
    hostel_id: uuid.UUID
    room_number: str
    guardian_name: str
    guardian_phone: str
    guardian_relation: str


class EnrollmentResponse(BaseModel):
    id: uuid.UUID
    name: str
    roll_number: str
    enrollment_status: str
    created_at: datetime

    model_config = {"from_attributes": True}


class StudentProfile(BaseModel):
    id: uuid.UUID
    user_id: uuid.UUID
    name: str
    phone: str
    roll_number: str
    room_number: str
    hostel_id: uuid.UUID
    hostel_name: Optional[str] = None
    enrollment_status: str
    current_status: str
    fee_receipt_url: Optional[str] = None
    guardian_name: Optional[str] = None
    guardian_phone: Optional[str] = None
    created_at: datetime

    model_config = {"from_attributes": True}


class ProfileUpdateRequest(BaseModel):
    room_number: str


class ProfileCorrectionRequest(BaseModel):
    field_name: str
    current_value: str
    requested_value: str
    reason: str


class RejectEnrollmentRequest(BaseModel):
    reason: str


class PermanentCheckoutRequest(BaseModel):
    reason: str
