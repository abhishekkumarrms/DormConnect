import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/auth/guardian_login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/movements_screen.dart';
import 'screens/leave_screen.dart';
import 'screens/leave_detail_screen.dart';
import 'screens/notices_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/sos/guardian_sos_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuth = auth.isAuthenticated;
      final isLogin = state.matchedLocation == '/login' ||
          state.matchedLocation.startsWith('/otp');
      if (!isAuth && !isLogin) return '/login';
      if (isAuth && isLogin) return '/home';
      return null;
    },
    routes: [
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
    ],
  );
});
