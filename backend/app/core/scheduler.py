import logging
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.interval import IntervalTrigger

logger = logging.getLogger(__name__)
scheduler = AsyncIOScheduler()


def start_scheduler(app):
    from app.core.database import AsyncSessionLocal
    from app.core.redis_client import get_redis_pool

    async def run_overdue_check():
        from app.services.gate_service import check_overdue_returns
        async with AsyncSessionLocal() as db:
            redis = await get_redis_pool()
            await check_overdue_returns(db, redis)

    scheduler.add_job(
        run_overdue_check,
        trigger=IntervalTrigger(minutes=5),
        id="check_overdue_returns",
        replace_existing=True,
    )

    scheduler.start()
    logger.info("Scheduler started")


def stop_scheduler():
    if scheduler.running:
        scheduler.shutdown()
