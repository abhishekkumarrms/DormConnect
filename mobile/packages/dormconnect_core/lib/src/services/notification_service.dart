import 'package:firebase_messaging/firebase_messaging.dart';
import '../api/api_client.dart';
import '../constants/api_constants.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background message handler — must be top-level
  // ignore: avoid_print
  print('[FCM] Background: ${message.notification?.title}');
}

class NotificationService {
  final ApiClient _client;
  NotificationService(this._client);

  Future<void> initialize() async {
    try {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await sendFcmTokenToBackend(token);
        }
        FirebaseMessaging.instance.onTokenRefresh.listen(
          sendFcmTokenToBackend,
        );
      }

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    } catch (_) {
      // Firebase not configured — skip silently
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // TODO: show local notification using flutter_local_notifications
    // ignore: avoid_print
    print('[FCM] Foreground: ${message.notification?.title}');
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    // TODO: navigate based on message.data['type']
    // ignore: avoid_print
    print('[FCM] Opened: ${message.data}');
  }

  Future<void> sendFcmTokenToBackend(String token) async {
    try {
      await _client.patch(
        '${ApiConstants.apiPrefix}${ApiConstants.updateFcmToken}',
        data: {'fcm_token': token},
      );
    } catch (_) {}
  }
}
