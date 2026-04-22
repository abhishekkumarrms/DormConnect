import random
import string
from typing import Optional
import redis.asyncio as aioredis


def generate_otp(length: int = 6) -> str:
    return "".join(random.choices(string.digits, k=length))


async def store_sms_otp(redis: aioredis.Redis, phone: str, otp: str, expire_seconds: int = 300) -> None:
    key = f"sms_otp:{phone}"
    await redis.setex(key, expire_seconds, otp)


async def verify_sms_otp(redis: aioredis.Redis, phone: str, otp: str) -> bool:
    key = f"sms_otp:{phone}"
    stored = await redis.get(key)
    if stored and stored == otp:
        await redis.delete(key)
        return True
    return False


async def generate_gate_otp(
    redis: aioredis.Redis,
    student_id: str,
    movement_type: str,
    destination: Optional[str] = None,
    expected_return: Optional[str] = None,
) -> str:
    otp = generate_otp(6)
    key = f"gate:{student_id}:{movement_type}"
    data = {"otp": otp}
    if destination:
        data["destination"] = destination
    if expected_return:
        data["expected_return"] = expected_return
    import json
    await redis.setex(key, 120, json.dumps(data))
    return otp


async def verify_gate_otp(
    redis: aioredis.Redis,
    student_id: str,
    movement_type: str,
    otp: str,
) -> bool:
    import json
    key = f"gate:{student_id}:{movement_type}"
    stored_raw = await redis.get(key)
    if not stored_raw:
        return False
    stored = json.loads(stored_raw)
    if stored.get("otp") == otp:
        await redis.delete(key)
        return True
    return False


async def get_gate_otp_data(redis: aioredis.Redis, student_id: str, movement_type: str) -> Optional[dict]:
    import json
    key = f"gate:{student_id}:{movement_type}"
    stored_raw = await redis.get(key)
    if not stored_raw:
        return None
    return json.loads(stored_raw)
