import uuid
from typing import Optional
from datetime import date, time
from sqlalchemy import String, ForeignKey, Enum as SAEnum, Date, Time
from sqlalchemy.orm import Mapped, mapped_column, relationship
import enum
from app.models.base import Base, TimestampMixin


class ShiftType(str, enum.Enum):
    MORNING = "MORNING"
    EVENING = "EVENING"
    NIGHT = "NIGHT"


class Shift(Base, TimestampMixin):
    __tablename__ = "shifts"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    caretaker_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), nullable=False)
    hostel_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("hostels.id"), nullable=False)
    shift_type: Mapped[ShiftType] = mapped_column(SAEnum(ShiftType), nullable=False)
    date: Mapped[date] = mapped_column(Date, nullable=False)
    start_time: Mapped[Optional[time]] = mapped_column(Time, nullable=True)
    end_time: Mapped[Optional[time]] = mapped_column(Time, nullable=True)
    handover_note: Mapped[Optional[str]] = mapped_column(String(2000), nullable=True)

    caretaker: Mapped["User"] = relationship("User", foreign_keys=[caretaker_id])
    hostel: Mapped["Hostel"] = relationship("Hostel", foreign_keys=[hostel_id])
