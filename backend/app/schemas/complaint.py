import uuid
from typing import Optional
from datetime import datetime
from pydantic import BaseModel


class ComplaintCreate(BaseModel):
    category: str
    description: str
    photo_url: Optional[str] = None


class UpdateEntry(BaseModel):
    updated_by_name: str
    old_status: str
    new_status: str
    note: Optional[str] = None
    created_at: datetime

    model_config = {"from_attributes": True}


class ComplaintResponse(BaseModel):
    id: uuid.UUID
    student_name: Optional[str] = None
    room_number: Optional[str] = None
    category: str
    status: str
    description: str
    photo_url: Optional[str] = None
    assigned_to_name: Optional[str] = None
    updates: list[UpdateEntry] = []
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}


class ComplaintAction(BaseModel):
    action: str  # ACCEPT, REJECT, PROGRESS, RESOLVE, ESCALATE, REOPEN
    note: Optional[str] = None
    escalate_to_id: Optional[uuid.UUID] = None
    assigned_to_id: Optional[uuid.UUID] = None


class ComplaintStats(BaseModel):
    total: int
    pending: int
    accepted: int
    in_progress: int
    resolved: int
    rejected: int
    escalated: int
    by_category: dict
