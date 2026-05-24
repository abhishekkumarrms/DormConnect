from fastapi import APIRouter
from app.api.v1 import (
    auth, students, gate, complaints, maintenance,
    leaves, visitors, mess, sos,
    communications, shifts, analytics, audit, admin, guardian,
)
from app.core.config import settings

api_router = APIRouter()
api_router.include_router(admin.router)
api_router.include_router(auth.router)
api_router.include_router(students.router)
api_router.include_router(gate.router)
api_router.include_router(complaints.router)
api_router.include_router(maintenance.router)
api_router.include_router(leaves.router)
api_router.include_router(visitors.router)
api_router.include_router(mess.router)
api_router.include_router(sos.router)
api_router.include_router(communications.router)
api_router.include_router(shifts.router)
api_router.include_router(analytics.router)
api_router.include_router(audit.router)
api_router.include_router(guardian.router)

if settings.ENVIRONMENT == "development":
    from app.api.v1 import dev
    api_router.include_router(dev.router)
