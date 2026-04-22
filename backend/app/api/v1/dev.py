"""
Development-only endpoints. Never exposed in production.
"""
from fastapi import APIRouter
from app.core.config import settings

router = APIRouter(prefix="/dev", tags=["dev"])


@router.get("/seed")
async def seed_db():
    if settings.ENVIRONMENT != "development":
        from fastapi import HTTPException
        raise HTTPException(status_code=403, detail="Not available in production")

    from app.core.database import AsyncSessionLocal
    from app.utils.seed import seed
    async with AsyncSessionLocal() as db:
        await seed(db)
    return {"message": "Database seeded"}


@router.get("/reset")
async def reset_db():
    if settings.ENVIRONMENT != "development":
        from fastapi import HTTPException
        raise HTTPException(status_code=403, detail="Not available in production")

    from app.core.database import AsyncSessionLocal
    from app.utils.seed import reset, seed
    async with AsyncSessionLocal() as db:
        await reset(db)
        await seed(db)
    return {"message": "Database reset and reseeded"}
