from fastapi import APIRouter, Header, HTTPException
from app.core.config import settings

router = APIRouter(prefix="/admin", tags=["admin"])


def _check_seed_secret(x_seed_secret: str = Header(...)):
    if not settings.SEED_SECRET:
        raise HTTPException(status_code=503, detail="SEED_SECRET not configured")
    if x_seed_secret != settings.SEED_SECRET:
        raise HTTPException(status_code=401, detail="Invalid seed secret")


@router.post("/seed")
async def seed_db(x_seed_secret: str = Header(...)):
    _check_seed_secret(x_seed_secret)
    from app.core.database import AsyncSessionLocal
    from app.utils.seed import seed
    async with AsyncSessionLocal() as db:
        await seed(db)
    return {"message": "Database seeded successfully"}


@router.post("/reset-seed")
async def reset_and_seed(x_seed_secret: str = Header(...)):
    _check_seed_secret(x_seed_secret)
    from app.core.database import AsyncSessionLocal
    from app.utils.seed import reset, seed
    async with AsyncSessionLocal() as db:
        await reset(db)
        await seed(db)
    return {"message": "Database reset and reseeded"}
