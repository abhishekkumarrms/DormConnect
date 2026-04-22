import uuid
from typing import Optional
from datetime import datetime
from pydantic import BaseModel


class BroadcastCreate(BaseModel):
    hostel_id: Optional[uuid.UUID] = None  # None = all hostels
    category: str  # GENERAL, IMPORTANT, MESS, HOLIDAY, EVENT
    title: str
    body: str
    scheduled_at: Optional[datetime] = None


class BroadcastResponse(BaseModel):
    id: uuid.UUID
    hostel_id: Optional[uuid.UUID] = None
    institution_id: uuid.UUID
    sent_by_name: Optional[str] = None
    category: str
    title: str
    body: str
    scheduled_at: Optional[datetime] = None
    sent_at: Optional[datetime] = None
    created_at: datetime

    model_config = {"from_attributes": True}


class NoticeCreate(BaseModel):
    hostel_id: Optional[uuid.UUID] = None
    category: str
    title: str
    body: str
    is_pinned: bool = False


class NoticeUpdate(BaseModel):
    title: Optional[str] = None
    body: Optional[str] = None
    is_pinned: Optional[bool] = None
    is_active: Optional[bool] = None


class NoticeResponse(BaseModel):
    id: uuid.UUID
    hostel_id: Optional[uuid.UUID] = None
    institution_id: uuid.UUID
    posted_by_name: Optional[str] = None
    category: str
    title: str
    body: str
    is_pinned: bool
    is_active: bool
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}
