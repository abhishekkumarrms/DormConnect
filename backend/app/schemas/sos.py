import uuid
from typing import Optional
from datetime import datetime
from pydantic import BaseModel


class SOSResponse(BaseModel):
    id: uuid.UUID
    student_name: Optional[str] = None
    room_number: Optional[str] = None
    hostel_id: uuid.UUID
    status: str
    responded_by_name: Optional[str] = None
    response_note: Optional[str] = None
    triggered_at: datetime
    responded_at: Optional[datetime] = None

    model_config = {"from_attributes": True}


class SOSRespondRequest(BaseModel):
    note: Optional[str] = None
