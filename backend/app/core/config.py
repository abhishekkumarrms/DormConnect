from pydantic_settings import BaseSettings
from typing import Optional


class Settings(BaseSettings):
    DATABASE_URL: str
    REDIS_URL: str = "redis://localhost:6379"
    SECRET_KEY: str
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60
    REFRESH_TOKEN_EXPIRE_DAYS: int = 30
    CLOUDINARY_CLOUD_NAME: Optional[str] = None
    CLOUDINARY_API_KEY: Optional[str] = None
    CLOUDINARY_API_SECRET: Optional[str] = None
    FCM_CREDENTIALS_PATH: Optional[str] = None
    # Base64-encoded Firebase service account JSON — use this on Railway instead of a file
    FCM_CREDENTIALS_JSON: Optional[str] = None
    SMS_API_KEY: Optional[str] = None
    SMS_SENDER_ID: str = "DRMCNT"
    ENVIRONMENT: str = "development"
    # Comma-separated allowed CORS origins for production
    # e.g. "https://myapp.railway.app,https://myapp.com"
    ALLOWED_ORIGINS: str = ""
    # Railway injects $PORT — default 8000 for local dev
    PORT: int = 8000

    model_config = {"env_file": ".env", "extra": "ignore"}


settings = Settings()
