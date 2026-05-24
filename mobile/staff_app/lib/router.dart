import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_keys.dart';

import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/staff_login_screen.dart';
import 'features/home/screens/home_shell.dart';
import 'features/dashboard/screens/role_aware_dashboard.dart';
import 'features/students/screens/students_screen.dart';
import 'features/students/screens/student_detail_screen.dart';
import 'features/students/screens/enrollment_review_screen.dart';
import 'features/gate/screens/gate_monitor_screen.dart';
import 'features/complaints/screens/complaints_screen.dart';
import 'features/complaints/screens/complaint_detail_screen.dart';
import 'features/maintenance/screens/maintenance_screen.dart';
import 'features/maintenance/screens/maintenance_detail_screen.dart';
import 'features/leaves/screens/leaves_screen.dart';
import 'features/leaves/screens/leave_detail_screen.dart';
import 'features/mess/screens/mess_screen.dart';
import 'features/visitors/screens/visitors_screen.dart';
import 'features/visitors/screens/visitor_detail_screen.dart';
import 'features/broadcasts/screens/broadcasts_screen.dart';
import 'features/broadcasts/screens/new_broadcast_screen.dart';
import 'features/broadcasts/screens/notices_screen.dart';
import 'features/shifts/screens/handover_screen.dart';
import 'features/analytics/screens/analytics_screen.dart';
import 'features/staff_mgmt/screens/staff_mgmt_screen.dart';
import 'features/sos/screens/sos_screen.dart';

class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  _RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final auth = _ref.read(authProvider);
    final loc = state.matchedLocation;

    if (auth.isInitializing) return loc == '/splash' ? null : '/splash';

    if (loc == '/splash') {
      return auth.isAuthenticated ? '/home/dashboard' : '/login';
    }

    if (!auth.isAuthenticated && loc != '/login') return '/login';
    if (auth.isAuthenticated && loc == '/login') return '/home/dashboard';
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
      GoRoute(path: '/splash', builder: (_, __) => const StaffSplashScreen()),
      GoRoute(
        path: '/login',
        builder: (_, __) => const StaffLoginScreen(),
      ),

      // ── Shell (bottom nav + drawer) ──────────────────────────────
      ShellRoute(
        builder: (_, __, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/home/dashboard', builder: (_, __) => const RoleAwareDashboard()),
          GoRoute(path: '/home/students',  builder: (_, __) => const StudentsScreen()),
          GoRoute(path: '/home/gate',       builder: (_, __) => const GateMonitorScreen()),
          GoRoute(path: '/home/complaints', builder: (_, __) => const ComplaintsScreen()),
          GoRoute(path: '/home/maintenance',builder: (_, __) => const MaintenanceScreen()),
          GoRoute(path: '/home/leaves',     builder: (_, __) => const LeavesScreen()),
          GoRoute(path: '/home/mess',       builder: (_, __) => const MessScreen()),
          GoRoute(path: '/home/visitors',   builder: (_, __) => const VisitorsScreen()),
          GoRoute(path: '/home/analytics',  builder: (_, __) => const AnalyticsScreen()),
          GoRoute(path: '/home/staff',      builder: (_, __) => const StaffMgmtScreen()),
          GoRoute(path: '/home/broadcasts', builder: (_, __) => const BroadcastsScreen()),
          GoRoute(path: '/home/notices',    builder: (_, __) => const NoticesScreen()),
        ],
      ),

      // ── Detail / full-screen routes (outside shell) ──────────────
      GoRoute(
        path: '/students/:id',
        builder: (_, state) => StudentDetailScreen(studentId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/students/enroll/:id',
        builder: (_, state) => EnrollmentReviewScreen(studentId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/complaint/:id',
        builder: (_, state) => ComplaintDetailScreen(complaintId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/maintenance/:id',
        builder: (_, state) => MaintenanceDetailScreen(requestId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/leaves/:id',
        builder: (_, state) => LeaveDetailScreen(leaveId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/visitors/:id',
        builder: (_, state) => VisitorDetailScreen(visitorId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/broadcasts/new', builder: (_, __) => const NewBroadcastScreen()),
      GoRoute(path: '/shift/handover',  builder: (_, __) => const HandoverScreen()),
      GoRoute(path: '/sos',             builder: (_, __) => const SosScreen()),
    ],
  );
});
