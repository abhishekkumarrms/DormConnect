import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  static const _tabs = [
    (icon: Icons.home_rounded, label: 'Home', path: '/home/dashboard'),
    (icon: Icons.door_front_door_rounded, label: 'Gate', path: '/home/gate'),
    (icon: Icons.assignment_rounded, label: 'Activity', path: '/home/activity'),
    (icon: Icons.person_rounded, label: 'Profile', path: '/home/profile'),
  ];

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    final i = _tabs.indexWhere((t) => loc.startsWith(t.path));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = _currentIndex(context);
    return Scaffold(
      body: Stack(
        children: [
          child,
          Positioned(
            bottom: 80,
            right: 20,
            child: _SosFab(),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        destinations: _tabs
            .map((t) => NavigationDestination(
                  icon: Icon(t.icon),
                  label: t.label,
                ))
            .toList(),
      ),
    );
  }
}

class _SosFab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_SosFab> createState() => _SosFabState();
}

class _SosFabState extends ConsumerState<_SosFab>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.go('/sos'),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.error,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: AppColors.error.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4))
            ],
          ),
          child: const Center(
            child: Text('SOS',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13)),
          ),
        ),
      );
}
