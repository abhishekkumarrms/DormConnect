from fastapi import APIRouter
from app.api.v1 import auth, students, gate, complaints, maintenance, leaves, visitors, mess, sos

api_router = APIRouter()
api_router.include_router(auth.router)
api_router.include_router(students.router)
api_router.include_router(gate.router)
api_router.include_router(complaints.router)
api_router.include_router(maintenance.router)
api_router.include_router(leaves.router)
api_router.include_router(visitors.router)
api_router.include_router(mess.router)
api_router.include_router(sos.router)
