import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShellScreen extends ConsumerWidget {
  final Widget child;
  const ShellScreen({super.key, required this.child});

  static const _tabs = [
    (icon: Icons.home_outlined, label: 'Home', path: '/dashboard'),
    (icon: Icons.beach_access_outlined, label: 'Leaves', path: '/leaves'),
    (icon: Icons.directions_walk_outlined, label: 'Movement', path: '/movement'),
    (icon: Icons.sos, label: 'SOS', path: '/sos'),
  ];

  int _idx(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    final i = _tabs.indexWhere((t) => loc.startsWith(t.path));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    );
  }
}
