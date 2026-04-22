import redis.asyncio as aioredis
from app.core.config import settings

redis_pool = None


async def get_redis_pool():
    global redis_pool
    if redis_pool is None:
        redis_pool = aioredis.from_url(settings.REDIS_URL, decode_responses=True)
    return redis_pool


async def get_redis():
    return await get_redis_pool()
