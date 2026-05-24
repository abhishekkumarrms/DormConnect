import uuid
from typing import Optional
from pydantic import BaseModel


class HostelHealthResponse(BaseModel):
    """Flutter-compatible hostel health model. Field names match dormconnect_core HostelHealth."""
    hostel_id: str
    hostel_name: str
    health_score: float
    total_students: int
    current_out: int
    complaints_pending: int
    maintenance_pending: int
    pending_leaves: Optional[int] = None
    pending_enrollments: Optional[int] = None


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
