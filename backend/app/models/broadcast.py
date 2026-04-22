import uuid
from typing import Optional
from datetime import datetime
from sqlalchemy import String, Boolean, ForeignKey, Enum as SAEnum, DateTime, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
import enum
from app.models.base import Base, TimestampMixin


class BroadcastCategory(str, enum.Enum):
    GENERAL = "GENERAL"
    IMPORTANT = "IMPORTANT"
    MESS = "MESS"
    HOLIDAY = "HOLIDAY"
    EVENT = "EVENT"


class Broadcast(Base, TimestampMixin):
    __tablename__ = "broadcasts"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    hostel_id: Mapped[Optional[uuid.UUID]] = mapped_column(ForeignKey("hostels.id"), nullable=True)
    institution_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("institutions.id"), nullable=False)
    sent_by: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), nullable=False)
    category: Mapped[BroadcastCategory] = mapped_column(SAEnum(BroadcastCategory), nullable=False)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    body: Mapped[str] = mapped_column(Text, nullable=False)
    scheduled_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), nullable=True)
    sent_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), nullable=True)

    hostel: Mapped[Optional["Hostel"]] = relationship("Hostel", foreign_keys=[hostel_id])
    institution: Mapped["Institution"] = relationship("Institution", foreign_keys=[institution_id])
    sender: Mapped["User"] = relationship("User", foreign_keys=[sent_by])


class Notice(Base, TimestampMixin):
    __tablename__ = "notices"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    hostel_id: Mapped[Optional[uuid.UUID]] = mapped_column(ForeignKey("hostels.id"), nullable=True)
    institution_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("institutions.id"), nullable=False)
    posted_by: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), nullable=False)
    category: Mapped[BroadcastCategory] = mapped_column(SAEnum(BroadcastCategory), nullable=False)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    body: Mapped[str] = mapped_column(Text, nullable=False)
    is_pinned: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)

    hostel: Mapped[Optional["Hostel"]] = relationship("Hostel", foreign_keys=[hostel_id])
    institution: Mapped["Institution"] = relationship("Institution", foreign_keys=[institution_id])
    poster: Mapped["User"] = relationship("User", foreign_keys=[posted_by])
