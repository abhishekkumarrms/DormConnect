import logging
from typing import Optional
from app.core.config import settings

logger = logging.getLogger(__name__)


async def send_fcm(user_ids: list[str], title: str, body: str, data: Optional[dict] = None) -> None:
    if settings.ENVIRONMENT == "development":
        logger.info(f"[DEV FCM] To: {user_ids} | Title: {title} | Body: {body} | Data: {data}")
        return

    try:
        import firebase_admin
        from firebase_admin import messaging

        if not firebase_admin._apps:
            import firebase_admin.credentials as cred
            import json, base64
            if settings.FCM_CREDENTIALS_JSON:
                # Railway: set FCM_CREDENTIALS_JSON to base64-encoded service account JSON
                creds_dict = json.loads(base64.b64decode(settings.FCM_CREDENTIALS_JSON))
                firebase_admin.initialize_app(cred.Certificate(creds_dict))
            elif settings.FCM_CREDENTIALS_PATH:
                firebase_admin.initialize_app(cred.Certificate(settings.FCM_CREDENTIALS_PATH))

        # Fetch FCM tokens for user_ids from DB — placeholder
        # In real impl: query users table for fcm_token where id in user_ids
        logger.warning("FCM send: token lookup not yet implemented for prod")
    except Exception as e:
        logger.error(f"FCM send failed: {e}")


async def send_sms(phone: str, message: str) -> None:
    if settings.ENVIRONMENT == "development":
        logger.info(f"[DEV SMS] To: {phone} | Message: {message}")
        return

    try:
        import httpx
        async with httpx.AsyncClient() as client:
            await client.post(
                "https://api.msg91.com/api/sendhttp.php",
                params={
                    "authkey": settings.SMS_API_KEY,
                    "mobiles": f"91{phone}",
                    "message": message,
                    "sender": settings.SMS_SENDER_ID,
                    "route": "4",
                },
                timeout=10,
            )
    except Exception as e:
        logger.error(f"SMS send failed: {e}")
