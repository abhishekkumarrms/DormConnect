import uuid
from typing import Optional
from datetime import datetime
from sqlalchemy import String, ForeignKey, Enum as SAEnum, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
import enum
from app.models.base import Base, TimestampMixin


class ComplaintCategory(str, enum.Enum):
    FOOD = "FOOD"
    STAFF_BEHAVIOR = "STAFF_BEHAVIOR"
    SECURITY = "SECURITY"
    ENVIRONMENT = "ENVIRONMENT"
    RAGGING = "RAGGING"
    OTHER = "OTHER"


class ComplaintStatus(str, enum.Enum):
    SUBMITTED = "SUBMITTED"
    ACCEPTED = "ACCEPTED"
    IN_PROGRESS = "IN_PROGRESS"
    RESOLVED = "RESOLVED"
    REJECTED = "REJECTED"
    ESCALATED = "ESCALATED"
    REOPENED = "REOPENED"


class Complaint(Base, TimestampMixin):
    __tablename__ = "complaints"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    student_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("students.id"), nullable=False)
    hostel_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("hostels.id"), nullable=False)
    category: Mapped[ComplaintCategory] = mapped_column(SAEnum(ComplaintCategory), nullable=False)
    status: Mapped[ComplaintStatus] = mapped_column(
        SAEnum(ComplaintStatus), default=ComplaintStatus.SUBMITTED, nullable=False
    )
    description: Mapped[str] = mapped_column(String(2000), nullable=False)
    photo_url: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    assigned_to: Mapped[Optional[uuid.UUID]] = mapped_column(ForeignKey("users.id"), nullable=True)
    escalated_to: Mapped[Optional[uuid.UUID]] = mapped_column(ForeignKey("users.id"), nullable=True)
    resolution_note: Mapped[Optional[str]] = mapped_column(String(1000), nullable=True)

    student: Mapped["Student"] = relationship("Student", foreign_keys=[student_id])
    hostel: Mapped["Hostel"] = relationship("Hostel", foreign_keys=[hostel_id])
    assignee: Mapped[Optional["User"]] = relationship("User", foreign_keys=[assigned_to])
    escalated_user: Mapped[Optional["User"]] = relationship("User", foreign_keys=[escalated_to])
    updates: Mapped[list["ComplaintUpdate"]] = relationship("ComplaintUpdate", back_populates="complaint")


class ComplaintUpdate(Base):
    __tablename__ = "complaint_updates"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    complaint_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("complaints.id"), nullable=False)
    updated_by: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), nullable=False)
    old_status: Mapped[ComplaintStatus] = mapped_column(SAEnum(ComplaintStatus), nullable=False)
    new_status: Mapped[ComplaintStatus] = mapped_column(SAEnum(ComplaintStatus), nullable=False)
    note: Mapped[Optional[str]] = mapped_column(String(1000), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)

    complaint: Mapped["Complaint"] = relationship("Complaint", back_populates="updates")
    updater: Mapped["User"] = relationship("User", foreign_keys=[updated_by])
