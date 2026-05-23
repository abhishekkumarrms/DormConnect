import traceback
from fastapi import APIRouter, Header, HTTPException
from app.core.config import settings

router = APIRouter(prefix="/admin", tags=["admin"])


def _verify(x_seed_secret: str):
    if not settings.SEED_SECRET:
        raise HTTPException(status_code=503, detail="SEED_SECRET not configured on server")
    if x_seed_secret != settings.SEED_SECRET:
        raise HTTPException(status_code=401, detail="Invalid seed secret")


@router.post("/seed")
async def seed_db(x_seed_secret: str = Header(...)):
    _verify(x_seed_secret)
    try:
        from app.core.database import AsyncSessionLocal
        from app.utils.seed import seed
        async with AsyncSessionLocal() as db:
            await seed(db)
        return {"message": "Database seeded successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"{type(e).__name__}: {e}\n{traceback.format_exc()}")


@router.post("/reset-seed")
async def reset_and_seed(x_seed_secret: str = Header(...)):
    _verify(x_seed_secret)
    try:
        from app.core.database import AsyncSessionLocal
        from app.utils.seed import reset, seed
        async with AsyncSessionLocal() as db:
            await reset(db)
            await seed(db)
        return {"message": "Database reset and reseeded"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"{type(e).__name__}: {e}\n{traceback.format_exc()}")
