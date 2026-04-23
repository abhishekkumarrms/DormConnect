import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dormconnect_core/dormconnect_core.dart';
import 'screens/auth/guard_login_screen.dart';
import 'screens/gate/live_requests_screen.dart';
import 'screens/gate/live_out_screen.dart';
import 'screens/visitors/visitor_screen.dart';
import 'screens/history/movement_history_screen.dart';
import 'screens/shell_screen.dart';

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
      GoRoute(path: '/login', builder: (_, __) => const GuardLoginScreen()),
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(path: '/gate', builder: (_, __) => const LiveRequestsScreen()),
          GoRoute(path: '/out', builder: (_, __) => const LiveOutScreen()),
          GoRoute(path: '/visitors', builder: (_, __) => const VisitorScreen()),
          GoRoute(path: '/history', builder: (_, __) => const MovementHistoryScreen()),
        ],
      ),
    ],
  );
});
