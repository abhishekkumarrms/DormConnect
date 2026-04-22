import uuid
from typing import Optional
from datetime import date
from sqlalchemy import String, Boolean, ForeignKey, Enum as SAEnum, Date, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
import enum
from app.models.base import Base, TimestampMixin


class LeaveType(str, enum.Enum):
    HOME = "HOME"
    MEDICAL = "MEDICAL"
    PERSONAL = "PERSONAL"
    ACADEMIC = "ACADEMIC"


class LeaveStatus(str, enum.Enum):
    SUBMITTED = "SUBMITTED"
    UNDER_REVIEW = "UNDER_REVIEW"
    GUARDIAN_CONTACTED = "GUARDIAN_CONTACTED"
    APPROVED = "APPROVED"
    REJECTED = "REJECTED"


class LeaveApplication(Base, TimestampMixin):
    __tablename__ = "leave_applications"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    student_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("students.id"), nullable=False)
    leave_type: Mapped[LeaveType] = mapped_column(SAEnum(LeaveType), nullable=False)
    status: Mapped[LeaveStatus] = mapped_column(
        SAEnum(LeaveStatus), default=LeaveStatus.SUBMITTED, nullable=False
    )
    from_date: Mapped[date] = mapped_column(Date, nullable=False)
    to_date: Mapped[date] = mapped_column(Date, nullable=False)
    reason: Mapped[str] = mapped_column(String(1000), nullable=False)
    destination: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    caretaker_id: Mapped[Optional[uuid.UUID]] = mapped_column(ForeignKey("users.id"), nullable=True)
    caretaker_note: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    guardian_confirmed: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    guardian_note: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    approved_by: Mapped[Optional[uuid.UUID]] = mapped_column(ForeignKey("users.id"), nullable=True)

    student: Mapped["Student"] = relationship("Student", foreign_keys=[student_id])
    caretaker: Mapped[Optional["User"]] = relationship("User", foreign_keys=[caretaker_id])
    approver: Mapped[Optional["User"]] = relationship("User", foreign_keys=[approved_by])
