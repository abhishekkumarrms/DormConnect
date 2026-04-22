"""
Seed script for DormConnect development environment.
Run with: python -m app.utils.seed
"""
import asyncio
import uuid
import logging
from datetime import datetime, timezone, date

from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import AsyncSessionLocal
from app.core.security import hash_password, hash_pin
from app.models.institution import Institution, Hostel
from app.models.user import User, Role
from app.models.student import Student, EnrollmentStatus, StudentStatus
from app.models.complaint import Complaint, ComplaintStatus, ComplaintCategory
from app.models.leave import LeaveApplication, LeaveType, LeaveStatus
from app.models.maintenance import MaintenanceRequest, MaintenanceStatus, MaintenanceCategory
from app.models.mess import MessMenu
from app.models.broadcast import Broadcast, Notice, BroadcastCategory

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

DEFAULT_PASSWORD = hash_password("password123")
DEFAULT_PIN = hash_pin("1234")


async def seed(db: AsyncSession) -> None:
    logger.info("Seeding DormConnect...")

    # 1. Institution
    institution = Institution(
        name="CSJMU Kanpur",
        address="Kanpur Nagar",
        city="Kanpur",
        state="Uttar Pradesh",
    )
    db.add(institution)
    await db.flush()
    logger.info(f"Institution: {institution.name} ({institution.id})")

    # 2. Hostels
    hostel_names = [
        "Boys Hostel 1", "Boys Hostel 2", "Boys Hostel 3",
        "Girls Hostel 1", "Girls Hostel 2", "Girls Hostel 3",
    ]
    hostels = []
    for name in hostel_names:
        h = Hostel(institution_id=institution.id, name=name, total_capacity=100)
        db.add(h)
        hostels.append(h)
    await db.flush()
    logger.info(f"Created {len(hostels)} hostels")

    # 3. Chief Warden
    cw = User(
        email="cw@dormconnect.dev",
        phone="9000000000",
        name="Chief Warden",
        role=Role.CHIEF_WARDEN,
        institution_id=institution.id,
        password_hash=DEFAULT_PASSWORD,
        is_active=True,
    )
    db.add(cw)

    # 4. Asst. Chief Warden
    acw = User(
        email="acw@dormconnect.dev",
        phone="9000000099",
        name="Asst. Chief Warden",
        role=Role.ASST_CHIEF_WARDEN,
        institution_id=institution.id,
        password_hash=DEFAULT_PASSWORD,
        is_active=True,
    )
    db.add(acw)
    await db.flush()

    # 5. Per-hostel staff
    wardens = []
    asst_wardens = []
    caretakers = []
    for i, hostel in enumerate(hostels, start=1):
        w = User(
            email=f"warden{i}@dormconnect.dev",
            phone=f"900000010{i}",
            name=f"Warden {i}",
            role=Role.WARDEN,
            hostel_id=hostel.id,
            institution_id=institution.id,
            password_hash=DEFAULT_PASSWORD,
            is_active=True,
        )
        aw = User(
            email=f"aw{i}@dormconnect.dev",
            phone=f"900000020{i}",
            name=f"Asst. Warden {i}",
            role=Role.ASST_WARDEN,
            hostel_id=hostel.id,
            institution_id=institution.id,
            password_hash=DEFAULT_PASSWORD,
            is_active=True,
        )
        ct = User(
            email=f"caretaker{i}@dormconnect.dev",
            phone=f"900000030{i}",
            name=f"Caretaker {i}",
            role=Role.CARETAKER,
            hostel_id=hostel.id,
            institution_id=institution.id,
            password_hash=DEFAULT_PASSWORD,
            is_active=True,
        )
        db.add(w)
        db.add(aw)
        db.add(ct)
        wardens.append(w)
        asst_wardens.append(aw)
        caretakers.append(ct)

    # 6. Guards
    guard1 = User(
        phone="9000000001",
        name="Guard 1",
        role=Role.GUARD,
        hostel_id=hostels[0].id,
        institution_id=institution.id,
        pin_hash=DEFAULT_PIN,
        is_active=True,
    )
    guard2 = User(
        phone="9000000002",
        name="Guard 2",
        role=Role.GUARD,
        hostel_id=hostels[1].id,
        institution_id=institution.id,
        pin_hash=DEFAULT_PIN,
        is_active=True,
    )
    db.add(guard1)
    db.add(guard2)
    await db.flush()
    logger.info("Staff accounts created")

    # 7. Students + Guardians
    student_data = [
        ("Rahul Kumar", "9100000001", "2021CS001", hostels[0], "101"),
        ("Priya Sharma", "9100000002", "2021CS002", hostels[3], "201"),
        ("Amit Singh", "9100000003", "2021EC001", hostels[0], "102"),
        ("Sneha Verma", "9100000004", "2021EC002", hostels[3], "202"),
        ("Raj Patel", "9100000005", "2021ME001", hostels[1], "101"),
        ("Nisha Gupta", "9100000006", "2021ME002", hostels[4], "201"),
        ("Vikram Yadav", "9100000007", "2021CI001", hostels[1], "102"),
        ("Anita Joshi", "9100000008", "2021CI002", hostels[4], "202"),
        ("Suresh Mishra", "9100000009", "2021MA001", hostels[2], "101"),
        ("Kavya Reddy", "9100000010", "2021MA002", hostels[5], "201"),
    ]

    students = []
    for name, phone, roll, hostel, room in student_data:
        # Guardian
        g_phone = str(int(phone) + 1000000)
        guardian = User(
            phone=g_phone,
            name=f"Parent of {name.split()[0]}",
            role=Role.GUARDIAN,
            institution_id=institution.id,
            is_active=True,
        )
        db.add(guardian)
        await db.flush()

        # Student user
        su = User(
            phone=phone,
            name=name,
            role=Role.STUDENT,
            hostel_id=hostel.id,
            institution_id=institution.id,
            is_active=True,
        )
        db.add(su)
        await db.flush()

        st = Student(
            user_id=su.id,
            roll_number=roll,
            room_number=room,
            hostel_id=hostel.id,
            guardian_user_id=guardian.id,
            enrollment_status=EnrollmentStatus.ACTIVE,
            fee_receipt_url="https://res.cloudinary.com/demo/image/upload/sample.pdf",
            current_status=StudentStatus.IN,
        )
        db.add(st)
        await db.flush()
        students.append(st)

    logger.info(f"Created {len(students)} students")

    # 8. Sample complaints
    complaint_data = [
        (students[0], ComplaintCategory.FOOD, "Food quality has degraded significantly this week.", ComplaintStatus.SUBMITTED),
        (students[1], ComplaintCategory.SECURITY, "Lights not working in the corridor near room 205.", ComplaintStatus.ACCEPTED),
        (students[2], ComplaintCategory.ENVIRONMENT, "Washroom cleanliness issue in block B.", ComplaintStatus.IN_PROGRESS),
        (students[3], ComplaintCategory.STAFF_BEHAVIOR, "Caretaker was rude during room inspection.", ComplaintStatus.RESOLVED),
        (students[4], ComplaintCategory.OTHER, "Wi-Fi signal is very weak in room 101.", ComplaintStatus.SUBMITTED),
    ]
    for st, cat, desc, status in complaint_data:
        c = Complaint(
            student_id=st.id,
            hostel_id=st.hostel_id,
            category=cat,
            status=status,
            description=desc,
        )
        db.add(c)

    # 9. Leave applications
    leave_data = [
        (students[0], LeaveType.HOME, date(2026, 4, 25), date(2026, 4, 30), LeaveStatus.SUBMITTED, "Going home for festival"),
        (students[1], LeaveType.MEDICAL, date(2026, 4, 22), date(2026, 4, 24), LeaveStatus.APPROVED, "Doctor appointment"),
        (students[2], LeaveType.PERSONAL, date(2026, 4, 28), date(2026, 5, 1), LeaveStatus.UNDER_REVIEW, "Family function"),
    ]
    for st, lt, fd, td, status, reason in leave_data:
        la = LeaveApplication(
            student_id=st.id,
            leave_type=lt,
            status=status,
            from_date=fd,
            to_date=td,
            reason=reason,
        )
        db.add(la)

    # 10. Maintenance requests
    maintenance_data = [
        (students[0], MaintenanceCategory.ELECTRICAL, "Fan not working in room 101.", MaintenanceStatus.SUBMITTED),
        (students[1], MaintenanceCategory.PLUMBING, "Tap dripping in bathroom.", MaintenanceStatus.ASSIGNED),
    ]
    for st, cat, desc, status in maintenance_data:
        mr = MaintenanceRequest(
            student_id=st.id,
            hostel_id=st.hostel_id,
            category=cat,
            status=status,
            description=desc,
            room_number=st.room_number,
        )
        db.add(mr)

    # 11. Today's mess menu for each hostel
    today = date.today()
    for hostel, caretaker in zip(hostels, caretakers):
        menu = MessMenu(
            hostel_id=hostel.id,
            date=today,
            breakfast="Poha, Chai, Banana",
            lunch="Dal, Rice, Roti, Sabzi, Salad",
            snacks="Samosa, Tea",
            dinner="Paneer Curry, Rice, Roti, Dal, Raita",
            posted_by=caretaker.id,
        )
        db.add(menu)

    # 12. Broadcasts
    bc1 = Broadcast(
        hostel_id=None,
        institution_id=institution.id,
        sent_by=cw.id,
        category=BroadcastCategory.IMPORTANT,
        title="Annual Examination Schedule",
        body="End semester examinations begin May 10. All students must return by May 9.",
        sent_at=datetime.now(timezone.utc),
    )
    bc2 = Broadcast(
        hostel_id=hostels[0].id,
        institution_id=institution.id,
        sent_by=caretakers[0].id,
        category=BroadcastCategory.GENERAL,
        title="Water Supply Interruption",
        body="Water supply will be off on April 23 from 10 AM to 2 PM for maintenance.",
        sent_at=datetime.now(timezone.utc),
    )
    db.add(bc1)
    db.add(bc2)

    # 13. Notices per hostel
    for i, hostel in enumerate(hostels):
        n1 = Notice(
            hostel_id=hostel.id,
            institution_id=institution.id,
            posted_by=wardens[i].id,
            category=BroadcastCategory.GENERAL,
            title="Hostel Rules Reminder",
            body="Entry gate closes at 10 PM. All students must be back before curfew.",
            is_pinned=True,
            is_active=True,
        )
        n2 = Notice(
            hostel_id=hostel.id,
            institution_id=institution.id,
            posted_by=caretakers[i].id,
            category=BroadcastCategory.MESS,
            title="Mess Holiday",
            body="Mess will remain closed on April 26 (Sunday). Make your own arrangements.",
            is_pinned=False,
            is_active=True,
        )
        n3 = Notice(
            hostel_id=hostel.id,
            institution_id=institution.id,
            posted_by=wardens[i].id,
            category=BroadcastCategory.EVENT,
            title="Cultural Night",
            body="Cultural night event on April 27 in the common room. All residents invited.",
            is_pinned=False,
            is_active=True,
        )
        db.add(n1)
        db.add(n2)
        db.add(n3)

    await db.commit()
    logger.info("Seed complete!")
    logger.info("=" * 50)
    logger.info("Login credentials:")
    logger.info("  Chief Warden:    cw@dormconnect.dev / password123")
    logger.info("  Asst CW:         acw@dormconnect.dev / password123")
    logger.info("  Caretaker 1:     caretaker1@dormconnect.dev / password123")
    logger.info("  Guard 1:         phone 9000000001, PIN 1234")
    logger.info("  Student 1:       phone 9100000001, OTP logged to console")
    logger.info("=" * 50)
    logger.info(f"Institution ID: {institution.id}")
    logger.info(f"Hostel 1 ID:    {hostels[0].id}")


async def reset(db: AsyncSession) -> None:
    """Drop all data by truncating tables in dependency order."""
    from sqlalchemy import text
    tables = [
        "notices", "broadcasts", "mess_offs", "mess_menus",
        "sos_alerts", "shifts", "audit_logs",
        "complaint_updates", "complaints",
        "maintenance_requests", "leave_applications",
        "visitors", "otp_tokens", "movement_logs",
        "students", "users", "hostels", "institutions",
    ]
    for table in tables:
        await db.execute(text(f"TRUNCATE TABLE {table} CASCADE"))
    await db.commit()
    logger.info("All data cleared")


async def main():
    import sys
    do_reset = "--reset" in sys.argv
    async with AsyncSessionLocal() as db:
        if do_reset:
            await reset(db)
        await seed(db)


if __name__ == "__main__":
    asyncio.run(main())
