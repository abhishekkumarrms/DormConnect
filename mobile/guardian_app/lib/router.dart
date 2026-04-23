import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dormconnect_core/dormconnect_core.dart';
import 'screens/auth/guardian_login_screen.dart';
import 'screens/dashboard/guardian_dashboard_screen.dart';
import 'screens/leaves/guardian_leaves_screen.dart';
import 'screens/movement/movement_screen.dart';
import 'screens/sos/guardian_sos_screen.dart';
import 'screens/shell_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuth = auth.isAuthenticated;
      final isLogin = state.matchedLocation == '/login' ||
          state.matchedLocation.startsWith('/otp');
      if (!isAuth && !isLogin) return '/login';
      if (isAuth && isLogin) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const GuardianLoginScreen()),
      GoRoute(
          path: '/otp',
          builder: (_, state) =>
              GuardianOtpScreen(phone: state.extra as String)),
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
              path: '/dashboard',
              builder: (_, __) => const GuardianDashboardScreen()),
          GoRoute(
              path: '/leaves', builder: (_, __) => const GuardianLeavesScreen()),
          GoRoute(
              path: '/movement',
              builder: (_, __) => const MovementScreen()),
          GoRoute(
              path: '/sos', builder: (_, __) => const GuardianSosScreen()),
        ],
      ),
    ],
  );
});
