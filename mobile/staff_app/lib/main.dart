import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_keys.dart';
import 'features/sos/screens/sos_alert_screen.dart';
import 'router.dart';

@pragma('vm:entry-point')
Future<void> _bgMessageHandler(RemoteMessage _) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_bgMessageHandler);
  } catch (_) {
    // No google-services.json — Firebase optional in dev
  }

  runApp(const ProviderScope(child: StaffApp()));
}

class StaffApp extends ConsumerStatefulWidget {
  const StaffApp({super.key});

  @override
  ConsumerState<StaffApp> createState() => _StaffAppState();
}

class _StaffAppState extends ConsumerState<StaffApp> {
  @override
  void initState() {
    super.initState();
    _initFcm();
  }

  Future<void> _initFcm() async {
    try {
      final svc = NotificationService(ref.read(apiClientProvider));
      await svc.initialize();

      // Foreground SOS → push full-screen alert over whatever is showing
      FirebaseMessaging.onMessage.listen((msg) {
        final type = msg.data['type'] as String?;
        if (type == 'sos') {
          navigatorKey.currentState?.push(
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (_) => SosAlertScreen(
                data: Map<String, dynamic>.from(msg.data),
              ),
            ),
          );
        }
      });

      // App opened from notification tap
      FirebaseMessaging.onMessageOpenedApp.listen((msg) {
        final type = msg.data['type'] as String?;
        final id = msg.data['id'] as String?;
        final router = ref.read(routerProvider);
        switch (type) {
          case 'complaint':
            if (id != null) router.go('/complaint/$id');
          case 'leave':
            if (id != null) router.go('/leaves/$id');
          case 'maintenance':
            if (id != null) router.go('/maintenance/$id');
          case 'sos':
            router.go('/sos');
          case 'enrollment':
            router.go('/home/students');
        }
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'DormConnect Staff',
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
