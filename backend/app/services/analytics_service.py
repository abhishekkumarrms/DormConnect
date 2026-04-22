import uuid
import logging
from datetime import date
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from fastapi import HTTPException

from app.models.student import Student, EnrollmentStatus, StudentStatus
from app.models.complaint import Complaint, ComplaintStatus
from app.models.maintenance import MaintenanceRequest, MaintenanceStatus
from app.models.leave import LeaveApplication, LeaveStatus
from app.models.movement import MovementLog
from app.models.user import User, Role
from app.models.institution import Institution, Hostel
from app.schemas.analytics import HostelStats, InstitutionOverview, StaffPerformance

logger = logging.getLogger(__name__)


async def get_hostel_health_score(hostel_id: uuid.UUID, db: AsyncSession) -> float:
    total_c = (await db.execute(
        select(func.count(Complaint.id)).where(Complaint.hostel_id == hostel_id)
    )).scalar_one() or 1

    resolved_c = (await db.execute(
        select(func.count(Complaint.id)).where(
            Complaint.hostel_id == hostel_id,
            Complaint.status == ComplaintStatus.RESOLVED,
        )
    )).scalar_one()

    total_m = (await db.execute(
        select(func.count(MaintenanceRequest.id)).where(MaintenanceRequest.hostel_id == hostel_id)
    )).scalar_one() or 1

    fixed_m = (await db.execute(
        select(func.count(MaintenanceRequest.id)).where(
            MaintenanceRequest.hostel_id == hostel_id,
            MaintenanceRequest.status == MaintenanceStatus.FIXED,
        )
    )).scalar_one()

    total_out = (await db.execute(
        select(func.count(Student.id)).where(
            Student.hostel_id == hostel_id,
            Student.current_status == StudentStatus.OUT,
        )
    )).scalar_one() or 1

    overdue = (await db.execute(
        select(func.count(MovementLog.id))
        .join(Student, MovementLog.student_id == Student.id)
        .where(
            Student.hostel_id == hostel_id,
            MovementLog.is_overdue == True,
            MovementLog.actual_return == None,
        )
    )).scalar_one()

    total_s = (await db.execute(
        select(func.count(Student.id)).where(Student.hostel_id == hostel_id)
    )).scalar_one() or 1

    pending_e = (await db.execute(
        select(func.count(Student.id)).where(
            Student.hostel_id == hostel_id,
            Student.enrollment_status == EnrollmentStatus.PENDING,
        )
    )).scalar_one()

    score = (
        (resolved_c / total_c) * 0.3
        + (fixed_m / total_m) * 0.2
        + 0.2
        + (1 - min(1.0, overdue / total_out)) * 0.2
        + (1 - min(1.0, pending_e / total_s)) * 0.1
    ) * 100

    return round(min(100.0, max(0.0, score)), 1)


async def get_hostel_stats(hostel_id: uuid.UUID, db: AsyncSession) -> HostelStats:
    today = date.today()
    hostel = await db.get(Hostel, hostel_id)
    if not hostel:
        raise HTTPException(status_code=404, detail="Hostel not found")

    total_s = (await db.execute(select(func.count(Student.id)).where(Student.hostel_id == hostel_id))).scalar_one()
    active_s = (await db.execute(select(func.count(Student.id)).where(Student.hostel_id == hostel_id, Student.enrollment_status == EnrollmentStatus.ACTIVE))).scalar_one()
    out_s = (await db.execute(select(func.count(Student.id)).where(Student.hostel_id == hostel_id, Student.current_status == StudentStatus.OUT))).scalar_one()
    leave_s = (await db.execute(
        select(func.count(LeaveApplication.id))
        .join(Student, LeaveApplication.student_id == Student.id)
        .where(Student.hostel_id == hostel_id, LeaveApplication.status == LeaveStatus.APPROVED, LeaveApplication.from_date <= today, LeaveApplication.to_date >= today)
    )).scalar_one()
    pending_c = (await db.execute(select(func.count(Complaint.id)).where(Complaint.hostel_id == hostel_id, Complaint.status.in_([ComplaintStatus.SUBMITTED, ComplaintStatus.ACCEPTED, ComplaintStatus.IN_PROGRESS])))).scalar_one()
    resolved_c = (await db.execute(select(func.count(Complaint.id)).where(Complaint.hostel_id == hostel_id, Complaint.status == ComplaintStatus.RESOLVED))).scalar_one()
    total_c = (await db.execute(select(func.count(Complaint.id)).where(Complaint.hostel_id == hostel_id))).scalar_one()
    pending_m = (await db.execute(select(func.count(MaintenanceRequest.id)).where(MaintenanceRequest.hostel_id == hostel_id, MaintenanceRequest.status != MaintenanceStatus.FIXED))).scalar_one()
    health_score = await get_hostel_health_score(hostel_id, db)

    return HostelStats(
        hostel_id=hostel_id,
        hostel_name=hostel.name,
        total_students=total_s,
        active_students=active_s,
        currently_out=out_s,
        on_leave_today=leave_s,
        pending_complaints=pending_c,
        resolved_complaints=resolved_c,
        total_complaints=total_c,
        pending_maintenance=pending_m,
        health_score=health_score,
    )


async def get_institution_overview(institution_id: uuid.UUID, db: AsyncSession) -> InstitutionOverview:
    institution = await db.get(Institution, institution_id)
    if not institution:
        raise HTTPException(status_code=404, detail="Institution not found")

    result = await db.execute(select(Hostel).where(Hostel.institution_id == institution_id))
    hostels = result.scalars().all()
    hostel_stats = [await get_hostel_stats(h.id, db) for h in hostels]

    return InstitutionOverview(
        institution_id=institution_id,
        institution_name=institution.name,
        total_students=sum(s.total_students for s in hostel_stats),
        currently_out=sum(s.currently_out for s in hostel_stats),
        hostels=hostel_stats,
    )


async def get_staff_performance(hostel_id: uuid.UUID, db: AsyncSession) -> list[StaffPerformance]:
    from app.models.complaint import ComplaintUpdate

    result = await db.execute(
        select(User).where(
            User.hostel_id == hostel_id,
            User.role.in_([Role.CARETAKER, Role.ASST_WARDEN, Role.WARDEN]),
            User.is_active == True,
        )
    )
    staff = result.scalars().all()
    perf_list = []

    for user in staff:
        complaints_resolved = (await db.execute(
            select(func.count(ComplaintUpdate.id)).where(
                ComplaintUpdate.updated_by == user.id,
                ComplaintUpdate.new_status == ComplaintStatus.RESOLVED,
            )
        )).scalar_one()

        leaves_processed = (await db.execute(
            select(func.count(LeaveApplication.id)).where(LeaveApplication.caretaker_id == user.id)
        )).scalar_one()

        perf_list.append(StaffPerformance(
            user_id=user.id,
            name=user.name,
            role=user.role.value,
            complaints_resolved=complaints_resolved,
            leaves_processed=leaves_processed,
        ))

    return perf_list
