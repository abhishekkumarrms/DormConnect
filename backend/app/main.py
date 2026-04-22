from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1.router import api_router
from app.core.config import settings


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    from app.core.redis_client import get_redis_pool
    await get_redis_pool()
    from app.core.scheduler import start_scheduler
    start_scheduler(app)
    yield
    # Shutdown
    from app.core.scheduler import stop_scheduler
    stop_scheduler()
    from app.core.redis_client import redis_pool
    if redis_pool:
        await redis_pool.aclose()


app = FastAPI(
    title="DormConnect API",
    description="Hostel Management Ecosystem API",
    version="0.1.0",
    lifespan=lifespan,
    openapi_url="/api/openapi.json",
    docs_url="/api/docs",
    redoc_url="/api/redoc",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"] if settings.ENVIRONMENT == "development" else [],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(api_router, prefix="/api/v1")


@app.get("/health")
async def health_check():
    return {"status": "ok", "service": "DormConnect API"}
