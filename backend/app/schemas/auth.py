import re
from typing import Optional
from pydantic import BaseModel, field_validator


def validate_indian_phone(v: str) -> str:
    cleaned = re.sub(r"[\s\-\+]", "", v)
    if cleaned.startswith("91") and len(cleaned) == 12:
        cleaned = cleaned[2:]
    if not re.match(r"^[6-9]\d{9}$", cleaned):
        raise ValueError("Invalid Indian phone number")
    return cleaned


class PhoneOTPRequest(BaseModel):
    phone: str

    @field_validator("phone")
    @classmethod
    def phone_validator(cls, v: str) -> str:
        return validate_indian_phone(v)


class VerifyOTPRequest(BaseModel):
    phone: str
    otp: str

    @field_validator("phone")
    @classmethod
    def phone_validator(cls, v: str) -> str:
        return validate_indian_phone(v)


class EmailLoginRequest(BaseModel):
    email: str
    password: str
    device_id: Optional[str] = None


class PINLoginRequest(BaseModel):
    phone: str
    pin: str
    device_id: Optional[str] = None

    @field_validator("phone")
    @classmethod
    def phone_validator(cls, v: str) -> str:
        return validate_indian_phone(v)


class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    role: str
    user_id: str
    scope: str = "full"  # "full" or "enrollment"
    enrollment_state: Optional[str] = None  # "REQUIRED" | "PENDING" | null


class RefreshRequest(BaseModel):
    refresh_token: str
