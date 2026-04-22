import uuid
from typing import Optional
from datetime import datetime
from pydantic import BaseModel


class VisitorCreate(BaseModel):
    visitor_name: str
    relation: str
    visitor_phone: str
    purpose: str
    expected_at: Optional[datetime] = None
    expected_duration_hours: Optional[int] = None


class VisitorResponse(BaseModel):
    id: uuid.UUID
    student_name: Optional[str] = None
    visitor_name: str
    relation: str
    visitor_phone: str
    purpose: str
    expected_at: Optional[datetime] = None
    expected_duration_hours: Optional[int] = None
    status: str
    approved_by_name: Optional[str] = None
    entry_at: Optional[datetime] = None
    exit_at: Optional[datetime] = None
    created_at: datetime

    model_config = {"from_attributes": True}
