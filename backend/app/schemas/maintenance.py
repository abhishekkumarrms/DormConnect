import uuid
from typing import Optional
from datetime import datetime
from pydantic import BaseModel


class MaintenanceCreate(BaseModel):
    category: str
    description: str
    room_number: str
    photo_url: Optional[str] = None


class MaintenanceResponse(BaseModel):
    id: uuid.UUID
    student_name: Optional[str] = None
    room_number: str
    category: str
    status: str
    description: str
    photo_url: Optional[str] = None
    assigned_to_name: Optional[str] = None
    scheduled_at: Optional[datetime] = None
    fixed_note: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}


class MaintenanceAction(BaseModel):
    action: str  # ASSIGN, SCHEDULE, PROGRESS, FIX
    assigned_to_id: Optional[uuid.UUID] = None
    scheduled_at: Optional[datetime] = None
    note: Optional[str] = None


class MaintenanceStats(BaseModel):
    total: int
    submitted: int
    assigned: int
    scheduled: int
    in_progress: int
    fixed: int
    by_category: dict
