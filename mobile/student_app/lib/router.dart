import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dormconnect_core/dormconnect_core.dart';
import 'screens/auth/phone_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/enroll_screen.dart';
import 'screens/home_screen.dart';
import 'screens/gate/gate_otp_screen.dart';
import 'screens/leave/leave_list_screen.dart';
import 'screens/leave/leave_apply_screen.dart';
import 'screens/complaint/complaint_list_screen.dart';
import 'screens/complaint/complaint_create_screen.dart';
import 'screens/mess/mess_screen.dart';
import 'screens/sos/sos_screen.dart';
import 'screens/profile/profile_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuth = auth.isAuthenticated;
      final isLoginRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/otp') ||
          state.matchedLocation.startsWith('/enroll');
      if (!isAuth && !isLoginRoute) return '/login';
      if (isAuth && isLoginRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const PhoneScreen()),
      GoRoute(
          path: '/otp',
          builder: (_, state) =>
              OtpScreen(phone: state.extra as String)),
      GoRoute(path: '/enroll', builder: (_, __) => const EnrollScreen()),
      ShellRoute(
        builder: (context, state, child) => HomeScreen(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const GateOtpScreen()),
          GoRoute(path: '/gate', builder: (_, __) => const GateOtpScreen()),
          GoRoute(
              path: '/leaves', builder: (_, __) => const LeaveListScreen()),
          GoRoute(
              path: '/leaves/apply',
              builder: (_, __) => const LeaveApplyScreen()),
          GoRoute(
              path: '/complaints',
              builder: (_, __) => const ComplaintListScreen()),
          GoRoute(
              path: '/complaints/create',
              builder: (_, __) => const ComplaintCreateScreen()),
          GoRoute(path: '/mess', builder: (_, __) => const MessScreen()),
          GoRoute(path: '/sos', builder: (_, __) => const SosScreen()),
          GoRoute(
              path: '/profile', builder: (_, __) => const ProfileScreen()),
        ],
      ),
    ],
  );
});
