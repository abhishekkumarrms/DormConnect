import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  static const _tabs = [
    (icon: Icons.door_front_door_outlined, label: 'Gate', path: '/gate'),
    (icon: Icons.beach_access_outlined, label: 'Leave', path: '/leaves'),
    (icon: Icons.report_problem_outlined, label: 'Complaints', path: '/complaints'),
    (icon: Icons.restaurant_menu_outlined, label: 'Mess', path: '/mess'),
    (icon: Icons.person_outline, label: 'Profile', path: '/profile'),
  ];

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    final idx = _tabs.indexWhere((t) => loc.startsWith(t.path));
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex(context),
        onTap: (i) => context.go(_tabs[i].path),
        items: _tabs
            .map((t) => BottomNavigationBarItem(
                  icon: Icon(t.icon),
                  label: t.label,
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/sos'),
        backgroundColor: AppColors.error,
        child: const Icon(Icons.sos, color: Colors.white),
      ),
    );
  }
}
