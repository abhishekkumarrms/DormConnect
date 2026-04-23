# Firebase Setup for DormConnect

Push notifications are optional. The apps run without Firebase configured.

## Add Firebase (optional)

1. Create a Firebase project at https://console.firebase.google.com
2. Add an Android app with the package name for each app:
   - `com.dormconnect.student_app`
   - `com.dormconnect.staff_app`
   - `com.dormconnect.guard_app`
   - `com.dormconnect.guardian_app`
3. Download `google-services.json` for each app and place it at:
   - `student_app/android/app/google-services.json`
   - `staff_app/android/app/google-services.json`
   - `guard_app/android/app/google-services.json`
   - `guardian_app/android/app/google-services.json`

## Without Firebase

Apps start and run normally. FCM token registration is skipped silently.
The backend will not send push notifications, but all other features work.

## Backend FCM endpoint

The notification service calls `POST /api/v1/auth/fcm-token` with body:
```json
{ "fcm_token": "<token>" }
```

Configure this route in the backend to store and use tokens for sending
targeted notifications via Firebase Admin SDK.
