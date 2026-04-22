import uuid
import logging
from datetime import datetime, timezone
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from fastapi import HTTPException

from app.models.sos import SOSAlert, SOSStatus
from app.models.student import Student
from app.models.user import User, Role
from app.schemas.sos import SOSResponse
from app.utils.audit import log_audit
from app.utils.notifications import send_fcm

logger = logging.getLogger(__name__)


async def trigger_sos(student_user: User, db: AsyncSession) -> SOSResponse:
    result = await db.execute(select(Student).where(Student.user_id == student_user.id))
    student = result.scalar_one_or_none()
    if not student:
        raise HTTPException(status_code=404, detail="Student profile not found")

    alert = SOSAlert(
        student_id=student.id,
        hostel_id=student.hostel_id,
        status=SOSStatus.TRIGGERED,
        triggered_at=datetime.now(timezone.utc),
    )
    db.add(alert)

    await log_audit(
        db,
        action="SOS_TRIGGERED",
        entity_type="SOSAlert",
        entity_id=str(alert.id) if alert.id else "pending",
        performed_by=student_user.id,
    )

    await db.commit()
    await db.refresh(alert)

    await send_fcm(
        [],  # In real impl: query caretaker + warden + guardian FCM tokens
        title="SOS EMERGENCY",
        body=f"{student_user.name} triggered an SOS alert! Room {student.room_number}",
        data={"type": "SOS", "student_id": str(student.id), "hostel_id": str(student.hostel_id)},
    )

    return await _build_response(alert, db)


async def respond_to_sos(
    sos_id: uuid.UUID, note: str, responder_user: User, db: AsyncSession
) -> SOSResponse:
    alert = await db.get(SOSAlert, sos_id)
    if not alert:
        raise HTTPException(status_code=404, detail="SOS alert not found")
    if alert.status == SOSStatus.RESPONDED:
        raise HTTPException(status_code=400, detail="SOS already responded to")

    alert.status = SOSStatus.RESPONDED
    alert.responded_by = responder_user.id
    alert.response_note = note
    alert.responded_at = datetime.now(timezone.utc)

    await log_audit(
        db,
        action="SOS_RESPONDED",
        entity_type="SOSAlert",
        entity_id=str(alert.id),
        performed_by=responder_user.id,
        new_value={"note": note},
    )

    await db.commit()
    await db.refresh(alert)
    return await _build_response(alert, db)


async def get_sos_history(hostel_id: uuid.UUID, db: AsyncSession) -> list[SOSResponse]:
    result = await db.execute(
        select(SOSAlert)
        .where(SOSAlert.hostel_id == hostel_id)
        .order_by(SOSAlert.triggered_at.desc())
        .limit(100)
    )
    alerts = result.scalars().all()
    return [await _build_response(a, db) for a in alerts]


async def _build_response(alert: SOSAlert, db: AsyncSession) -> SOSResponse:
    student_name = None
    room_number = None
    if alert.student_id:
        row = await db.execute(
            select(Student, User)
            .join(User, Student.user_id == User.id)
            .where(Student.id == alert.student_id)
        )
        sr = row.one_or_none()
        if sr:
            student_name = sr.User.name
            room_number = sr.Student.room_number

    responded_by_name = None
    if alert.responded_by:
        u = await db.get(User, alert.responded_by)
        if u:
            responded_by_name = u.name

    return SOSResponse(
        id=alert.id,
        student_name=student_name,
        room_number=room_number,
        hostel_id=alert.hostel_id,
        status=alert.status.value,
        responded_by_name=responded_by_name,
        response_note=alert.response_note,
        triggered_at=alert.triggered_at,
        responded_at=alert.responded_at,
    )
