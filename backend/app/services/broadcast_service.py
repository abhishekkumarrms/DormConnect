import uuid
import logging
from datetime import datetime, timezone
from typing import Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, or_
from fastapi import HTTPException

from app.models.broadcast import Broadcast, Notice, BroadcastCategory
from app.models.user import User, Role
from app.models.institution import Institution, Hostel
from app.schemas.broadcast import BroadcastCreate, BroadcastResponse, NoticeCreate, NoticeUpdate, NoticeResponse
from app.utils.notifications import send_fcm

logger = logging.getLogger(__name__)

MULTI_HOSTEL_ROLES = {Role.ASST_CHIEF_WARDEN, Role.CHIEF_WARDEN}


async def send_broadcast(sender_user: User, data: BroadcastCreate, db: AsyncSession) -> BroadcastResponse:
    if data.hostel_id is None and sender_user.role not in MULTI_HOSTEL_ROLES:
        raise HTTPException(
            status_code=403,
            detail="Only Chief Warden / Asst. Chief Warden can broadcast to all hostels",
        )

    try:
        category = BroadcastCategory(data.category)
    except ValueError:
        raise HTTPException(status_code=400, detail=f"Invalid category: {data.category}")

    institution_id = sender_user.institution_id
    if not institution_id:
        raise HTTPException(status_code=400, detail="Sender has no institution assigned")

    sent_at = None if data.scheduled_at else datetime.now(timezone.utc)

    broadcast = Broadcast(
        hostel_id=data.hostel_id,
        institution_id=institution_id,
        sent_by=sender_user.id,
        category=category,
        title=data.title,
        body=data.body,
        scheduled_at=data.scheduled_at,
        sent_at=sent_at,
    )
    db.add(broadcast)
    await db.commit()
    await db.refresh(broadcast)

    if sent_at:
        await send_fcm([], title=data.title, body=data.body, data={"type": "BROADCAST", "category": data.category})

    return await _build_broadcast_response(broadcast, db)


async def get_broadcasts(hostel_id: uuid.UUID, db: AsyncSession, limit: int = 50) -> list[BroadcastResponse]:
    result = await db.execute(
        select(Broadcast)
        .where(or_(Broadcast.hostel_id == hostel_id, Broadcast.hostel_id == None))
        .order_by(Broadcast.created_at.desc())
        .limit(limit)
    )
    broadcasts = result.scalars().all()
    return [await _build_broadcast_response(b, db) for b in broadcasts]


async def create_notice(sender_user: User, data: NoticeCreate, db: AsyncSession) -> NoticeResponse:
    try:
        category = BroadcastCategory(data.category)
    except ValueError:
        raise HTTPException(status_code=400, detail=f"Invalid category: {data.category}")

    institution_id = sender_user.institution_id
    if not institution_id:
        raise HTTPException(status_code=400, detail="Sender has no institution assigned")

    notice = Notice(
        hostel_id=data.hostel_id,
        institution_id=institution_id,
        posted_by=sender_user.id,
        category=category,
        title=data.title,
        body=data.body,
        is_pinned=data.is_pinned,
        is_active=True,
    )
    db.add(notice)
    await db.commit()
    await db.refresh(notice)
    return await _build_notice_response(notice, db)


async def get_notices(hostel_id: uuid.UUID, db: AsyncSession) -> list[NoticeResponse]:
    result = await db.execute(
        select(Notice)
        .where(
            Notice.is_active == True,
            or_(Notice.hostel_id == hostel_id, Notice.hostel_id == None),
        )
        .order_by(Notice.is_pinned.desc(), Notice.created_at.desc())
    )
    notices = result.scalars().all()
    return [await _build_notice_response(n, db) for n in notices]


async def update_notice(notice_id: uuid.UUID, data: NoticeUpdate, actor_user: User, db: AsyncSession) -> NoticeResponse:
    notice = await db.get(Notice, notice_id)
    if not notice:
        raise HTTPException(status_code=404, detail="Notice not found")

    if data.title is not None:
        notice.title = data.title
    if data.body is not None:
        notice.body = data.body
    if data.is_pinned is not None:
        notice.is_pinned = data.is_pinned
    if data.is_active is not None:
        notice.is_active = data.is_active

    await db.commit()
    await db.refresh(notice)
    return await _build_notice_response(notice, db)


async def delete_notice(notice_id: uuid.UUID, actor_user: User, db: AsyncSession) -> dict:
    notice = await db.get(Notice, notice_id)
    if not notice:
        raise HTTPException(status_code=404, detail="Notice not found")
    notice.is_active = False
    await db.commit()
    return {"message": "Notice deleted"}


async def _build_broadcast_response(broadcast: Broadcast, db: AsyncSession) -> BroadcastResponse:
    sender_name = None
    if broadcast.sent_by:
        u = await db.get(User, broadcast.sent_by)
        if u:
            sender_name = u.name
    return BroadcastResponse(
        id=broadcast.id,
        hostel_id=broadcast.hostel_id,
        institution_id=broadcast.institution_id,
        sent_by_name=sender_name,
        category=broadcast.category.value,
        title=broadcast.title,
        body=broadcast.body,
        scheduled_at=broadcast.scheduled_at,
        sent_at=broadcast.sent_at,
        created_at=broadcast.created_at,
    )


async def _build_notice_response(notice: Notice, db: AsyncSession) -> NoticeResponse:
    poster_name = None
    if notice.posted_by:
        u = await db.get(User, notice.posted_by)
        if u:
            poster_name = u.name
    return NoticeResponse(
        id=notice.id,
        hostel_id=notice.hostel_id,
        institution_id=notice.institution_id,
        posted_by_name=poster_name,
        category=notice.category.value,
        title=notice.title,
        body=notice.body,
        is_pinned=notice.is_pinned,
        is_active=notice.is_active,
        created_at=notice.created_at,
        updated_at=notice.updated_at,
    )
