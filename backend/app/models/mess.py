import uuid
from typing import Optional
from datetime import date
from sqlalchemy import String, Boolean, ForeignKey, Date
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.models.base import Base, TimestampMixin


class MessMenu(Base, TimestampMixin):
    __tablename__ = "mess_menus"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    hostel_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("hostels.id"), nullable=False)
    date: Mapped[date] = mapped_column(Date, nullable=False)
    breakfast: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    lunch: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    snacks: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    dinner: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    posted_by: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), nullable=False)

    hostel: Mapped["Hostel"] = relationship("Hostel", foreign_keys=[hostel_id])
    poster: Mapped["User"] = relationship("User", foreign_keys=[posted_by])


class MessOff(Base, TimestampMixin):
    __tablename__ = "mess_offs"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    student_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("students.id"), nullable=False)
    hostel_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("hostels.id"), nullable=False)
    from_date: Mapped[date] = mapped_column(Date, nullable=False)
    to_date: Mapped[date] = mapped_column(Date, nullable=False)
    reason: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    is_approved: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    approved_by: Mapped[Optional[uuid.UUID]] = mapped_column(ForeignKey("users.id"), nullable=True)

    student: Mapped["Student"] = relationship("Student", foreign_keys=[student_id])
    hostel: Mapped["Hostel"] = relationship("Hostel", foreign_keys=[hostel_id])
    approver: Mapped[Optional["User"]] = relationship("User", foreign_keys=[approved_by])
