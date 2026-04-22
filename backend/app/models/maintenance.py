import uuid
from typing import Optional
from datetime import datetime
from sqlalchemy import String, ForeignKey, Enum as SAEnum, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
import enum
from app.models.base import Base, TimestampMixin


class MaintenanceCategory(str, enum.Enum):
    ELECTRICAL = "ELECTRICAL"
    PLUMBING = "PLUMBING"
    FURNITURE = "FURNITURE"
    INTERNET = "INTERNET"
    CLEANLINESS = "CLEANLINESS"
    OTHER = "OTHER"


class MaintenanceStatus(str, enum.Enum):
    SUBMITTED = "SUBMITTED"
    ASSIGNED = "ASSIGNED"
    SCHEDULED = "SCHEDULED"
    IN_PROGRESS = "IN_PROGRESS"
    FIXED = "FIXED"


class MaintenanceRequest(Base, TimestampMixin):
    __tablename__ = "maintenance_requests"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    student_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("students.id"), nullable=False)
    hostel_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("hostels.id"), nullable=False)
    category: Mapped[MaintenanceCategory] = mapped_column(SAEnum(MaintenanceCategory), nullable=False)
    status: Mapped[MaintenanceStatus] = mapped_column(
        SAEnum(MaintenanceStatus), default=MaintenanceStatus.SUBMITTED, nullable=False
    )
    description: Mapped[str] = mapped_column(String(2000), nullable=False)
    photo_url: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    room_number: Mapped[str] = mapped_column(String(50), nullable=False)
    assigned_to: Mapped[Optional[uuid.UUID]] = mapped_column(ForeignKey("users.id"), nullable=True)
    scheduled_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), nullable=True)
    fixed_note: Mapped[Optional[str]] = mapped_column(String(1000), nullable=True)

    student: Mapped["Student"] = relationship("Student", foreign_keys=[student_id])
    hostel: Mapped["Hostel"] = relationship("Hostel", foreign_keys=[hostel_id])
    assignee: Mapped[Optional["User"]] = relationship("User", foreign_keys=[assigned_to])
