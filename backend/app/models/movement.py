import uuid
from typing import Optional
from datetime import datetime
from sqlalchemy import String, Boolean, ForeignKey, Enum as SAEnum, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
import enum
from app.models.base import Base


class MovementType(str, enum.Enum):
    OUT = "OUT"
    IN = "IN"
    MANUAL = "MANUAL"


class MovementLog(Base):
    __tablename__ = "movement_logs"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    student_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("students.id"), nullable=False)
    type: Mapped[MovementType] = mapped_column(SAEnum(MovementType), nullable=False)
    destination: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    expected_return: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), nullable=True)
    actual_return: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), nullable=True)
    guard_id: Mapped[Optional[uuid.UUID]] = mapped_column(ForeignKey("users.id"), nullable=True)
    is_overdue: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    is_flagged: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    note: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)

    student: Mapped["Student"] = relationship("Student", foreign_keys=[student_id])
    guard: Mapped[Optional["User"]] = relationship("User", foreign_keys=[guard_id])


class OTPToken(Base):
    __tablename__ = "otp_tokens"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    student_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("students.id"), nullable=False)
    otp_code: Mapped[str] = mapped_column(String(6), nullable=False)
    movement_type: Mapped[MovementType] = mapped_column(SAEnum(MovementType), nullable=False)
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    is_used: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)

    student: Mapped["Student"] = relationship("Student", foreign_keys=[student_id])
