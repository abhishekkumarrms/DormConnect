import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/phone_input_screen.dart';
import 'features/auth/screens/otp_verify_screen.dart';
import 'features/auth/screens/enrollment_screen.dart';
import 'features/auth/screens/pending_approval_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/home/screens/dashboard_tab.dart';
import 'features/gate/screens/gate_tab.dart';
import 'features/gate/screens/movement_history_screen.dart';
import 'features/complaints/screens/activity_tab.dart';
import 'features/complaints/screens/new_complaint_screen.dart';
import 'features/complaints/screens/complaint_detail_screen.dart';
import 'features/complaints/screens/new_maintenance_screen.dart';
import 'features/complaints/screens/maintenance_detail_screen.dart';
import 'features/leave/screens/leaves_screen.dart';
import 'features/leave/screens/new_leave_screen.dart';
import 'features/leave/screens/leave_detail_screen.dart';
import 'features/mess/screens/mess_screen.dart';
import 'features/visitors/screens/new_visitor_screen.dart';
import 'features/broadcasts/screens/broadcasts_screen.dart';
import 'features/broadcasts/screens/notices_screen.dart';
import 'features/profile/screens/profile_tab.dart';
import 'features/sos/screens/sos_screen.dart';

class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  _RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final auth = _ref.read(authProvider);
    final loc = state.matchedLocation;
    if (loc == '/splash') return null;
    if (auth.isLoading) return null;

    const authRoutes = ['/auth/phone', '/auth/otp', '/auth/enroll', '/auth/pending'];
    final onAuthRoute = authRoutes.any((p) => loc.startsWith(p));

    // Enrollment-scope: route by enrollment state
    if (auth.hasEnrollmentToken) {
      if (auth.enrollmentState == 'REQUIRED') {
        return loc.startsWith('/auth/enroll') ? null : '/auth/enroll';
      }
      if (auth.enrollmentState == 'PENDING') {
        return loc == '/auth/pending' ? null : '/auth/pending';
      }
      // Unknown enrollment state — send to form
      return loc.startsWith('/auth/enroll') ? null : '/auth/enroll';
    }

    // Not authenticated at all
    if (!auth.isAuthenticated && !onAuthRoute) return '/auth/phone';

    // Fully authenticated on an auth route
    if (auth.isAuthenticated && onAuthRoute) return '/home/dashboard';

    return null;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/auth/phone', builder: (_, __) => const PhoneInputScreen()),
      GoRoute(
        path: '/auth/otp',
        builder: (_, state) => OtpVerifyScreen(
          phone: state.uri.queryParameters['phone'] ?? '',
        ),
      ),
      GoRoute(path: '/auth/enroll', builder: (_, __) => const EnrollmentScreen()),
      GoRoute(path: '/auth/pending', builder: (_, __) => const PendingApprovalScreen()),

      ShellRoute(
        builder: (context, state, child) => HomeScreen(child: child),
        routes: [
          GoRoute(path: '/home/dashboard', builder: (_, __) => const DashboardTab()),
          GoRoute(path: '/home/gate', builder: (_, __) => const GateTab()),
          GoRoute(path: '/home/activity', builder: (_, __) => const ActivityTab()),
          GoRoute(path: '/home/profile', builder: (_, __) => const ProfileTab()),
        ],
      ),

      GoRoute(path: '/leave', builder: (_, __) => const LeavesScreen()),
      GoRoute(path: '/leave/new', builder: (_, __) => const NewLeaveScreen()),
      GoRoute(
        path: '/leave/:id',
        builder: (_, state) => LeaveDetailScreen(leaveId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/complaint/new', builder: (_, __) => const NewComplaintScreen()),
      GoRoute(
        path: '/complaint/:id',
        builder: (_, state) => ComplaintDetailScreen(complaintId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/maintenance/new', builder: (_, __) => const NewMaintenanceScreen()),
      GoRoute(
        path: '/maintenance/:id',
        builder: (_, state) => MaintenanceDetailScreen(requestId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/gate/history', builder: (_, __) => const MovementHistoryScreen()),
      GoRoute(path: '/mess', builder: (_, __) => const MessScreen()),
      GoRoute(path: '/visitor/new', builder: (_, __) => const NewVisitorScreen()),
      GoRoute(path: '/broadcasts', builder: (_, __) => const BroadcastsScreen()),
      GoRoute(path: '/notices', builder: (_, __) => const NoticesScreen()),
      GoRoute(path: '/sos', builder: (_, __) => const SosScreen()),
    ],
  );
});
