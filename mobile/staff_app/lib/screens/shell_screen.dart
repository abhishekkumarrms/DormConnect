import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

class ShellScreen extends ConsumerWidget {
  final Widget child;
  const ShellScreen({super.key, required this.child});

  static const _tabs = [
    (icon: Icons.dashboard_outlined, label: 'Dashboard', path: '/dashboard'),
    (icon: Icons.people_outline, label: 'Students', path: '/students'),
    (icon: Icons.beach_access_outlined, label: 'Leaves', path: '/leaves'),
    (icon: Icons.report_problem_outlined, label: 'Issues', path: '/complaints'),
    (icon: Icons.more_horiz, label: 'More', path: '/mess'),
  ];

  int _idx(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    final i = _tabs.indexWhere((t) => loc.startsWith(t.path));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx(context),
        onTap: (i) => context.go(_tabs[i].path),
        items: _tabs
            .map((t) =>
                BottomNavigationBarItem(icon: Icon(t.icon), label: t.label))
            .toList(),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration:
                  const BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DcAvatar(
                      name: user?.name ?? 'Staff',
                      radius: 28),
                  const SizedBox(height: 8),
                  Text(user?.name ?? 'Staff',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                  Text(
                      AppConstants.roleLabels[user?.role.name] ??
                          user?.role.name ??
                          '',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            ListTile(
                leading: const Icon(Icons.build_outlined),
                title: const Text('Maintenance'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/maintenance');
                }),
            ListTile(
                leading: const Icon(Icons.restaurant_menu_outlined),
                title: const Text('Mess Count'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/mess');
                }),
            ListTile(
                leading: const Icon(Icons.sos),
                title: const Text('SOS Alerts'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/sos');
                }),
            const Spacer(),
            ListTile(
              leading:
                  const Icon(Icons.logout, color: AppColors.error),
              title: const Text('Logout',
                  style: TextStyle(color: AppColors.error)),
              onTap: () => ref.read(authProvider.notifier).logout(),
            ),
          ],
        ),
      ),
    );
  }
}
