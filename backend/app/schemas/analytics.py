import uuid
from typing import Optional
from pydantic import BaseModel


class HostelStats(BaseModel):
    hostel_id: uuid.UUID
    hostel_name: str
    total_students: int
    active_students: int
    currently_out: int
    on_leave_today: int
    pending_complaints: int
    resolved_complaints: int
    total_complaints: int
    pending_maintenance: int
    health_score: float


class InstitutionOverview(BaseModel):
    institution_id: uuid.UUID
    institution_name: str
    total_students: int
    currently_out: int
    hostels: list[HostelStats]


class StaffPerformance(BaseModel):
    user_id: uuid.UUID
    name: str
    role: str
    complaints_resolved: int
    leaves_processed: int
    avg_response_hours: Optional[float] = None
