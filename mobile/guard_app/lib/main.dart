import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Firebase optional — no crash without google-services.json
  try {
    await Firebase.initializeApp();
  } catch (_) {}

  await Hive.initFlutter();

  runApp(const ProviderScope(child: GuardApp()));
}

class GuardApp extends ConsumerWidget {
  const GuardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'DormConnect Guard',
      debugShowCheckedModeBanner: false,
      // Light mode only — guards work in all lighting
      themeMode: ThemeMode.light,
      theme: AppTheme.light.copyWith(
        textTheme: AppTheme.light.textTheme.apply(
          // 1.1× base font scale for readability
          fontSizeFactor: 1.1,
        ),
        // Keep screen on: set window flags via AnnotatedRegion
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
