import uuid
from typing import Optional
from datetime import datetime
from sqlalchemy import String, ForeignKey, Enum as SAEnum, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
import enum
from app.models.base import Base


class SOSStatus(str, enum.Enum):
    TRIGGERED = "TRIGGERED"
    RESPONDED = "RESPONDED"


class SOSAlert(Base):
    __tablename__ = "sos_alerts"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    student_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("students.id"), nullable=False)
    hostel_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("hostels.id"), nullable=False)
    status: Mapped[SOSStatus] = mapped_column(
        SAEnum(SOSStatus), default=SOSStatus.TRIGGERED, nullable=False
    )
    responded_by: Mapped[Optional[uuid.UUID]] = mapped_column(ForeignKey("users.id"), nullable=True)
    response_note: Mapped[Optional[str]] = mapped_column(String(1000), nullable=True)
    triggered_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    responded_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), nullable=True)

    student: Mapped["Student"] = relationship("Student", foreign_keys=[student_id])
    hostel: Mapped["Hostel"] = relationship("Hostel", foreign_keys=[hostel_id])
    responder: Mapped[Optional["User"]] = relationship("User", foreign_keys=[responded_by])
