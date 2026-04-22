import pytest
from unittest.mock import AsyncMock, MagicMock, patch
import uuid


@pytest.mark.asyncio
async def test_generate_otp():
    from app.core.otp import generate_otp
    otp = generate_otp(6)
    assert len(otp) == 6
    assert otp.isdigit()


@pytest.mark.asyncio
async def test_store_and_verify_otp():
    from app.core.otp import store_sms_otp, verify_sms_otp

    redis_mock = AsyncMock()
    redis_mock.get = AsyncMock(return_value="123456")
    redis_mock.delete = AsyncMock()

    await store_sms_otp(redis_mock, "9000000001", "123456")
    result = await verify_sms_otp(redis_mock, "9000000001", "123456")
    assert result is True


@pytest.mark.asyncio
async def test_verify_wrong_otp():
    from app.core.otp import verify_sms_otp

    redis_mock = AsyncMock()
    redis_mock.get = AsyncMock(return_value="123456")

    result = await verify_sms_otp(redis_mock, "9000000001", "999999")
    assert result is False


def test_hash_and_verify_password():
    from app.core.security import hash_password, verify_password
    hashed = hash_password("password123")
    assert verify_password("password123", hashed) is True
    assert verify_password("wrong", hashed) is False


def test_hash_and_verify_pin():
    from app.core.security import hash_pin, verify_pin
    hashed = hash_pin("1234")
    assert verify_pin("1234", hashed) is True
    assert verify_pin("9999", hashed) is False


def test_create_and_decode_tokens():
    from app.core.security import create_access_token, create_refresh_token, decode_token
    data = {"sub": str(uuid.uuid4()), "role": "STUDENT"}
    access = create_access_token(data)
    refresh = create_refresh_token(data)

    access_payload = decode_token(access)
    assert access_payload is not None
    assert access_payload["type"] == "access"

    refresh_payload = decode_token(refresh)
    assert refresh_payload is not None
    assert refresh_payload["type"] == "refresh"


def test_decode_invalid_token():
    from app.core.security import decode_token
    result = decode_token("invalid.token.here")
    assert result is None
