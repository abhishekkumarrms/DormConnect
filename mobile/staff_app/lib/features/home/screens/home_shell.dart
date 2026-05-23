import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/role_permissions.dart';

class HomeShell extends ConsumerWidget {
  final Widget child;
  const HomeShell({super.key, required this.child});

  static List<({IconData icon, String label, String path})> _tabsForRole(
      UserRole role) {
    final tabs = <({IconData icon, String label, String path})>[];
    tabs.add((
      icon: Icons.dashboard_outlined,
      label: 'Dashboard',
      path: '/home/dashboard',
    ));
    if (RolePermissions.showStudentsTab(role)) {
      tabs.add((
        icon: Icons.people_outline,
        label: 'Students',
        path: '/home/students',
      ));
    }
    tabs.add((
      icon: Icons.sensor_door_outlined,
      label: 'Gate',
      path: '/home/gate',
    ));
    tabs.add((
      icon: Icons.report_problem_outlined,
      label: 'Issues',
      path: '/home/complaints',
    ));
    tabs.add((
      icon: Icons.beach_access_outlined,
      label: 'Leaves',
      path: '/home/leaves',
    ));
    if (RolePermissions.showMessTab(role)) {
      tabs.add((
        icon: Icons.restaurant_outlined,
        label: 'Mess',
        path: '/home/mess',
      ));
    }
    if (RolePermissions.showVisitorsTab(role)) {
      tabs.add((
        icon: Icons.person_pin_outlined,
        label: 'Visitors',
        path: '/home/visitors',
      ));
    }
    if (RolePermissions.showAnalyticsTab(role)) {
      tabs.add((
        icon: Icons.bar_chart_rounded,
        label: 'Analytics',
        path: '/home/analytics',
      ));
    }
    if (RolePermissions.showStaffMgmtTab(role)) {
      tabs.add((
        icon: Icons.manage_accounts_outlined,
        label: 'Staff',
        path: '/home/staff',
      ));
    }
    return tabs;
  }

  int _currentIdx(BuildContext context,
      List<({IconData icon, String label, String path})> tabs) {
    final loc = GoRouterState.of(context).matchedLocation;
    final i = tabs.indexWhere((t) => loc.startsWith(t.path));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final role = user?.role ?? UserRole.caretaker;
    final tabs = _tabsForRole(role);
    final idx = _currentIdx(context, tabs);

    // Use NavigationBar for <= 5 tabs, NavigationDrawer-based for more
    if (tabs.length <= 5) {
      return Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: idx,
          onDestinationSelected: (i) => context.go(tabs[i].path),
          destinations: tabs
              .map((t) => NavigationDestination(
                    icon: Icon(t.icon),
                    label: t.label,
                  ))
              .toList(),
        ),
        floatingActionButton: _sosFab(context, role),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx < 5 ? idx : 0,
        onDestinationSelected: (i) => context.go(tabs[i].path),
        destinations: tabs
            .take(4)
            .map((t) => NavigationDestination(
                  icon: Icon(t.icon),
                  label: t.label,
                ))
            .toList()
          ..add(const NavigationDestination(
            icon: Icon(Icons.more_horiz_rounded),
            label: 'More',
          )),
      ),
      drawer: _buildDrawer(context, ref, user, role, tabs),
      floatingActionButton: _sosFab(context, role),
    );
  }

  Widget? _sosFab(BuildContext context, UserRole role) {
    if (!role.isStaff) return null;
    return null; // SOS navigated from drawer/notification
  }

  Widget _buildDrawer(
    BuildContext context,
    WidgetRef ref,
    User? user,
    UserRole role,
    List<({IconData icon, String label, String path})> tabs,
  ) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DcAvatar(name: user?.name ?? 'Staff', radius: 28),
                const SizedBox(height: 8),
                Text(
                  user?.name ?? 'Staff',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
                Text(
                  role.displayName,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7), fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (final t in tabs)
                  ListTile(
                    leading: Icon(t.icon),
                    title: Text(t.label),
                    onTap: () {
                      Navigator.pop(context);
                      context.go(t.path);
                    },
                  ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.campaign_outlined),
                  title: const Text('Broadcasts'),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/home/broadcasts');
                  },
                ),
                if (RolePermissions.showShiftsTab(role))
                  ListTile(
                    leading: const Icon(Icons.handshake_outlined),
                    title: const Text('Shift Handover'),
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/shift/handover');
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.sos_rounded, color: AppColors.error),
                  title: const Text('SOS Alerts',
                      style: TextStyle(color: AppColors.error)),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/sos');
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Logout',
                style: TextStyle(color: AppColors.error)),
            onTap: () => ref.read(authProvider.notifier).logout(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
