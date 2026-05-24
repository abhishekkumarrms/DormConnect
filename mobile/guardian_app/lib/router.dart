import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/splash_screen.dart';
import 'screens/auth/guardian_login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/movements_screen.dart';
import 'screens/leave_screen.dart';
import 'screens/leave_detail_screen.dart';
import 'screens/notices_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/sos/guardian_sos_screen.dart';
import 'screens/notification_settings_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  _RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final auth = _ref.read(authProvider);
    final loc = state.matchedLocation;

    if (auth.isInitializing) return loc == '/splash' ? null : '/splash';

    final isAuth = auth.isAuthenticated;
    final isLogin =
        loc == '/login' || loc == '/splash' || loc.startsWith('/otp');

    if (loc == '/splash') return isAuth ? '/home' : '/login';

    // Role guard — if authenticated but not guardian, force logout and show login
    if (isAuth && auth.user?.role != UserRole.guardian) {
      _ref.read(authProvider.notifier).logout();
      return '/login';
    }

    if (!isAuth && !isLogin) return '/login';
    if (isAuth && isLogin) return '/home';
    return null;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const GuardianSplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const GuardianLoginScreen()),
      GoRoute(
          path: '/otp',
          builder: (_, state) =>
              GuardianOtpScreen(phone: state.extra as String)),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/movements', builder: (_, __) => const MovementsScreen()),
      GoRoute(path: '/leaves', builder: (_, __) => const LeaveScreen()),
      GoRoute(
        path: '/leaves/:id',
        builder: (_, state) =>
            LeaveDetailScreen(leaveId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/notices', builder: (_, __) => const NoticesScreen()),
      GoRoute(path: '/contact', builder: (_, __) => const ContactScreen()),
      GoRoute(path: '/sos', builder: (_, __) => const GuardianSosScreen()),
      GoRoute(
          path: '/settings/notifications',
          builder: (_, __) => const NotificationSettingsScreen()),
    ],
  );
});
