import uuid
from typing import Optional
from sqlalchemy import String, Boolean, ForeignKey, Enum as SAEnum
from sqlalchemy.orm import Mapped, mapped_column, relationship
import enum
from app.models.base import Base, TimestampMixin


class Role(str, enum.Enum):
    CHIEF_WARDEN = "CHIEF_WARDEN"
    ASST_CHIEF_WARDEN = "ASST_CHIEF_WARDEN"
    WARDEN = "WARDEN"
    ASST_WARDEN = "ASST_WARDEN"
    CARETAKER = "CARETAKER"
    GUARD = "GUARD"
    STUDENT = "STUDENT"
    GUARDIAN = "GUARDIAN"


class User(Base, TimestampMixin):
    __tablename__ = "users"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    email: Mapped[Optional[str]] = mapped_column(String(255), unique=True, nullable=True)
    phone: Mapped[str] = mapped_column(String(20), unique=True, nullable=False)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    role: Mapped[Role] = mapped_column(SAEnum(Role), nullable=False)
    hostel_id: Mapped[Optional[uuid.UUID]] = mapped_column(ForeignKey("hostels.id"), nullable=True)
    institution_id: Mapped[Optional[uuid.UUID]] = mapped_column(ForeignKey("institutions.id"), nullable=True)
    password_hash: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    pin_hash: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    device_id: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    fcm_token: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)

    hostel: Mapped[Optional["Hostel"]] = relationship("Hostel", foreign_keys=[hostel_id])
    institution: Mapped[Optional["Institution"]] = relationship("Institution", foreign_keys=[institution_id])
