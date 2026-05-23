import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  _RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final auth = _ref.read(authProvider);
    if (auth.isLoading) return null;
    final isAuth = auth.isAuthenticated;
    final isLogin = state.matchedLocation == '/login';
    if (!isAuth && !isLogin) return '/login';
    if (isAuth && isLogin) return '/dashboard';
    return null;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const StaffLoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            HomeShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (_, __) => const RoleAwareDashboard(),
          ),
          GoRoute(
            path: '/students',
            builder: (_, __) => const StudentsScreen(),
          ),
          GoRoute(
            path: '/students/:id',
            builder: (_, state) => StudentDetailScreen(
                studentId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/enrollment/:id',
            builder: (_, state) => EnrollmentReviewScreen(
                studentId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/gate',
            builder: (_, __) => const GateMonitorScreen(),
          ),
          GoRoute(
            path: '/complaints',
            builder: (_, __) => const ComplaintsScreen(),
          ),
          GoRoute(
            path: '/complaint/:id',
            builder: (_, state) => ComplaintDetailScreen(
                complaintId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/maintenance',
            builder: (_, __) => const MaintenanceScreen(),
          ),
          GoRoute(
            path: '/maintenance/:id',
            builder: (_, state) => MaintenanceDetailScreen(
                requestId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/leaves',
            builder: (_, __) => const LeavesScreen(),
          ),
          GoRoute(
            path: '/leaves/:id',
            builder: (_, state) => LeaveDetailScreen(
                leaveId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/mess',
            builder: (_, __) => const MessScreen(),
          ),
          GoRoute(
            path: '/visitors',
            builder: (_, __) => const VisitorsScreen(),
          ),
          GoRoute(
            path: '/visitors/:id',
            builder: (_, state) => VisitorDetailScreen(
                visitorId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/broadcasts',
            builder: (_, __) => const BroadcastsScreen(),
          ),
          GoRoute(
            path: '/broadcasts/new',
            builder: (_, __) => const NewBroadcastScreen(),
          ),
          GoRoute(
            path: '/notices',
            builder: (_, __) => const NoticesScreen(),
          ),
          GoRoute(
            path: '/handover',
            builder: (_, __) => const HandoverScreen(),
          ),
          GoRoute(
            path: '/analytics',
            builder: (_, __) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: '/staff',
            builder: (_, __) => const StaffMgmtScreen(),
          ),
        ],
      ),
    ],
  );
});
