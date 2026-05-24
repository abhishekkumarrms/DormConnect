import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'router.dart';

@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  } catch (_) {}

  await Hive.initFlutter();

  runApp(const ProviderScope(child: GuardianApp()));
}

class GuardianApp extends ConsumerStatefulWidget {
  const GuardianApp({super.key});

  @override
  ConsumerState<GuardianApp> createState() => _GuardianAppState();
}

class _GuardianAppState extends ConsumerState<GuardianApp> {
  @override
  void initState() {
    super.initState();
    _initFcm();
  }

  Future<void> _initFcm() async {
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      final initial = await messaging.getInitialMessage();
      if (initial != null) _handleMessageOpenedApp(initial);
    } catch (_) {}
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] as String?;
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;

    switch (type) {
      case 'leave_update':
        DcSnackbar.success(ctx,
            message.notification?.body ?? 'Leave application updated');
      case 'movement':
        DcSnackbar.success(ctx,
            message.notification?.body ?? 'Student movement recorded');
      case 'sos':
        DcSnackbar.error(ctx, message.notification?.body ?? 'SOS Alert!');
      default:
        if (message.notification != null) {
          DcSnackbar.success(
              ctx, message.notification!.body ?? 'New notification');
        }
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] as String?;
    final router = navigatorKey.currentContext != null
        ? ref.read(routerProvider)
        : null;
    if (router == null) return;

    switch (type) {
      case 'leave_update':
        final id = data['leave_id'] as String?;
        if (id != null) router.push('/leaves/$id');
      case 'movement':
        router.push('/movements');
      case 'sos':
        router.push('/sos');
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'DormConnect Parent',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.light.copyWith(
        textTheme: AppTheme.light.textTheme.apply(
          fontSizeFactor: 1.1,
        ),
      ),
      routerConfig: router,
    );
  }
}
