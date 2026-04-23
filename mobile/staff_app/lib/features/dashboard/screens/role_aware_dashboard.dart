import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/caretaker_dashboard.dart';
import '../widgets/warden_dashboard.dart';
import '../widgets/chief_warden_dashboard.dart';

class RoleAwareDashboard extends ConsumerWidget {
  const RoleAwareDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final role = user?.role ?? UserRole.caretaker;

    return switch (role) {
      UserRole.caretaker => CaretakerDashboard(user: user),
      UserRole.asstWarden => WardenDashboard(user: user),
      UserRole.warden => WardenDashboard(user: user),
      UserRole.asstChiefWarden => ChiefWardenDashboard(user: user),
      UserRole.chiefWarden => ChiefWardenDashboard(user: user),
      _ => _UnknownRoleDashboard(role: role),
    };
  }
}

class _UnknownRoleDashboard extends StatelessWidget {
  final UserRole role;
  const _UnknownRoleDashboard({required this.role});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Text('Role: ${role.displayName}',
              style: const TextStyle(fontSize: 16)),
        ),
      );
}
