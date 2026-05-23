import uuid
from typing import Optional
from datetime import datetime
from pydantic import BaseModel, Field, ConfigDict


class EnrollmentRequest(BaseModel):
    name: str = Field(..., min_length=2, max_length=100)
    phone: str = Field(..., pattern=r"^[6-9]\d{9}$")
    roll_number: str = Field(..., min_length=3, max_length=50)
    hostel_id: uuid.UUID
    room_number: str = Field(..., min_length=1, max_length=20)
    guardian_name: str = Field(..., min_length=2, max_length=100)
    guardian_phone: str = Field(..., pattern=r"^[6-9]\d{9}$")
    guardian_relation: str = Field(..., max_length=50)


class EnrollmentResponse(BaseModel):
    id: uuid.UUID
    name: str
    roll_number: str
    enrollment_status: str
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


class PendingEnrollmentResponse(BaseModel):
    id: uuid.UUID
    name: str
    phone: str
    roll_number: str
    room_number: str
    hostel_id: uuid.UUID
    hostel_name: Optional[str] = None
    guardian_name: Optional[str] = None
    guardian_phone: Optional[str] = None
    guardian_relation: Optional[str] = None
    enrollment_status: str
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


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
    guardian_name: Optional[str] = None
    guardian_phone: Optional[str] = None
    guardian_relation: Optional[str] = None
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


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
