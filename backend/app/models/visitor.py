import uuid
from typing import Optional
from datetime import datetime
from sqlalchemy import String, Integer, ForeignKey, Enum as SAEnum, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
import enum
from app.models.base import Base, TimestampMixin


class VisitorStatus(str, enum.Enum):
    REQUESTED = "REQUESTED"
    APPROVED = "APPROVED"
    REJECTED = "REJECTED"
    INSIDE = "INSIDE"
    EXITED = "EXITED"


class Visitor(Base, TimestampMixin):
    __tablename__ = "visitors"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    student_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("students.id"), nullable=False)
    hostel_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("hostels.id"), nullable=False)
    visitor_name: Mapped[str] = mapped_column(String(255), nullable=False)
    relation: Mapped[str] = mapped_column(String(100), nullable=False)
    visitor_phone: Mapped[str] = mapped_column(String(20), nullable=False)
    purpose: Mapped[str] = mapped_column(String(500), nullable=False)
    expected_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), nullable=True)
    expected_duration_hours: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    status: Mapped[VisitorStatus] = mapped_column(
        SAEnum(VisitorStatus), default=VisitorStatus.REQUESTED, nullable=False
    )
    approved_by: Mapped[Optional[uuid.UUID]] = mapped_column(ForeignKey("users.id"), nullable=True)
    guard_entry_id: Mapped[Optional[uuid.UUID]] = mapped_column(ForeignKey("users.id"), nullable=True)
    entry_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), nullable=True)
    exit_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), nullable=True)

    student: Mapped["Student"] = relationship("Student", foreign_keys=[student_id])
    hostel: Mapped["Hostel"] = relationship("Hostel", foreign_keys=[hostel_id])
    approver: Mapped[Optional["User"]] = relationship("User", foreign_keys=[approved_by])
    guard: Mapped[Optional["User"]] = relationship("User", foreign_keys=[guard_entry_id])
