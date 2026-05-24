import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/gate_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/gate_screen.dart';
import 'screens/confirm_screen.dart';
import 'screens/manual_entry_screen.dart';
import 'screens/shift_log_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final loc = state.matchedLocation;

      // Wait for Hive/token restore
      if (auth.isInitializing) {
        return loc == '/splash' ? null : '/splash';
      }

      final isAuth = auth.isAuthenticated;
      final isLogin = loc == '/login';
      final isSplash = loc == '/splash';

      if (!isAuth && !isLogin) return '/login';
      if (isAuth && (isLogin || isSplash)) return '/gate';
      if (isSplash && !isAuth) return '/login';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/gate',
        builder: (_, __) => const GateScreen(),
      ),
      GoRoute(
        path: '/confirm',
        builder: (_, state) =>
            ConfirmScreen(request: state.extra as PendingRequest),
      ),
      GoRoute(
        path: '/manual',
        builder: (_, __) => const ManualEntryScreen(),
      ),
      GoRoute(
        path: '/shift-log',
        builder: (_, __) => const ShiftLogScreen(),
      ),
    ],
  );
});
