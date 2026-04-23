import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase optional — no crash without google-services.json
  try {
    await Firebase.initializeApp();
  } catch (_) {}

  await Hive.initFlutter();

  runApp(const ProviderScope(child: GuardianApp()));
}

class GuardianApp extends ConsumerWidget {
  const GuardianApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
