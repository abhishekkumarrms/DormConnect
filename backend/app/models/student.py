import uuid
from typing import Optional
from datetime import datetime
from sqlalchemy import String, ForeignKey, Enum as SAEnum, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
import enum
from app.models.base import Base, TimestampMixin


class EnrollmentStatus(str, enum.Enum):
    PENDING = "PENDING"
    ACTIVE = "ACTIVE"
    INACTIVE = "INACTIVE"
    CHECKED_OUT = "CHECKED_OUT"


class StudentStatus(str, enum.Enum):
    IN = "IN"
    OUT = "OUT"


class Student(Base, TimestampMixin):
    __tablename__ = "students"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), unique=True, nullable=False)
    roll_number: Mapped[str] = mapped_column(String(100), nullable=False)
    room_number: Mapped[str] = mapped_column(String(50), nullable=False)
    hostel_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("hostels.id"), nullable=False)
    guardian_user_id: Mapped[Optional[uuid.UUID]] = mapped_column(ForeignKey("users.id"), nullable=True)
    guardian_name: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    guardian_phone: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    guardian_relation: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    enrollment_status: Mapped[EnrollmentStatus] = mapped_column(
        SAEnum(EnrollmentStatus), default=EnrollmentStatus.PENDING, nullable=False
    )
    permanent_checkout_date: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), nullable=True)
    current_status: Mapped[StudentStatus] = mapped_column(
        SAEnum(StudentStatus), default=StudentStatus.IN, nullable=False
    )

    user: Mapped["User"] = relationship("User", foreign_keys=[user_id])
    guardian: Mapped[Optional["User"]] = relationship("User", foreign_keys=[guardian_user_id])
    hostel: Mapped["Hostel"] = relationship("Hostel", foreign_keys=[hostel_id])
