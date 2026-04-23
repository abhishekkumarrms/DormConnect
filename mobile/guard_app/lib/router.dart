import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/gate_provider.dart';
import 'screens/login_screen.dart';
import 'screens/gate_screen.dart';
import 'screens/confirm_screen.dart';
import 'screens/manual_entry_screen.dart';
import 'screens/shift_log_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuth = auth.isAuthenticated;
      final isLogin = state.matchedLocation == '/login';
      if (!isAuth && !isLogin) return '/login';
      if (isAuth && isLogin) return '/gate';
      return null;
    },
    routes: [
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
        builder: (_, state) => ConfirmScreen(
            request: state.extra as PendingRequest),
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
