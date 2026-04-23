import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dormconnect_core/dormconnect_core.dart';
import 'screens/auth/staff_login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/students/student_list_screen.dart';
import 'screens/students/student_detail_screen.dart';
import 'screens/leaves/leave_list_screen.dart';
import 'screens/complaints/complaint_list_screen.dart';
import 'screens/maintenance/maintenance_list_screen.dart';
import 'screens/mess/mess_count_screen.dart';
import 'screens/sos/sos_list_screen.dart';
import 'screens/shell_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuth = auth.isAuthenticated;
      final isLogin = state.matchedLocation == '/login';
      if (!isAuth && !isLogin) return '/login';
      if (isAuth && isLogin) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const StaffLoginScreen()),
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
          GoRoute(path: '/students', builder: (_, __) => const StudentListScreen()),
          GoRoute(
            path: '/students/:id',
            builder: (_, state) =>
                StudentDetailScreen(studentId: state.pathParameters['id']!),
          ),
          GoRoute(path: '/leaves', builder: (_, __) => const LeaveListScreen()),
          GoRoute(path: '/complaints', builder: (_, __) => const ComplaintListScreen()),
          GoRoute(path: '/maintenance', builder: (_, __) => const MaintenanceListScreen()),
          GoRoute(path: '/mess', builder: (_, __) => const MessCountScreen()),
          GoRoute(path: '/sos', builder: (_, __) => const SosListScreen()),
        ],
      ),
    ],
  );
});
