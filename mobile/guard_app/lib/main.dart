import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'router.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (_) {}

  await Hive.initFlutter();

  // Keep screen on — guards need continuous display at the gate
  await WakelockPlus.enable();

  runApp(const ProviderScope(child: GuardApp()));
}

class GuardApp extends ConsumerStatefulWidget {
  const GuardApp({super.key});

  @override
  ConsumerState<GuardApp> createState() => _GuardAppState();
}

class _GuardAppState extends ConsumerState<GuardApp> {
  @override
  void initState() {
    super.initState();
    _initFcm();
  }

  Future<void> _initFcm() async {
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();

      // Foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Tapped notification when app in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // App opened from terminated via notification
      final initial = await messaging.getInitialMessage();
      if (initial != null) _handleMessageOpenedApp(initial);
    } catch (_) {}
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    final title = message.notification?.title ?? 'DormConnect Guard';
    final body = message.notification?.body ?? '';
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            if (body.isNotEmpty) Text(body),
          ],
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: const Color(0xFF1E293B),
      ),
    );
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    final type = message.data['type'] as String?;
    if (type == 'gate_request') {
      // Navigate to gate screen where new requests will appear via polling
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/gate', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'DormConnect Guard',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.light.copyWith(
        textTheme: AppTheme.light.textTheme.apply(fontSizeFactor: 1.1),
        appBarTheme: AppTheme.light.appBarTheme.copyWith(
          backgroundColor: const Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      routerConfig: router,
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: child!,
      ),
    );
  }
}
