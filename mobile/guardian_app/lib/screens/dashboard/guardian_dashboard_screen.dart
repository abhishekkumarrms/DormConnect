import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _childLeavesProvider = FutureProvider<List<LeaveApplication>>((ref) async {
  return ref.watch(leaveApiProvider).list(limit: 5);
});

class GuardianDashboardScreen extends ConsumerWidget {
  const GuardianDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final leaves = ref.watch(_childLeavesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DormConnect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(_childLeavesProvider),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DcCard(
                child: Row(children: [
                  const Icon(Icons.family_restroom,
                      size: 40, color: AppColors.primary),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Welcome back',
                          style: TextStyle(color: AppColors.textSecondary)),
                      Text(user?.name ?? 'Guardian',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: _QuickAction(
                    icon: Icons.beach_access_outlined,
                    label: 'Leave Status',
                    color: AppColors.primary,
                    onTap: () => context.go('/leaves'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.directions_walk_outlined,
                    label: 'Movement',
                    color: AppColors.info,
                    onTap: () => context.go('/movement'),
                  ),
                ),
              ]),
              const SizedBox(height: 24),
              const Text('Recent Leaves',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              leaves.when(
                loading: () => const DcShimmerList(count: 3),
                error: (e, _) => Text(e.toString()),
                data: (list) => list.isEmpty
                    ? const DcEmptyState(
                        icon: Icons.beach_access_outlined,
                        title: 'No leave applications',
                      )
                    : Column(
                        children: list
                            .map((l) => Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 8),
                                  child: _LeaveItem(leave: l),
                                ))
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => DcCard(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class _LeaveItem extends StatelessWidget {
  final LeaveApplication leave;
  const _LeaveItem({required this.leave});

  @override
  Widget build(BuildContext context) => DcCard(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${leave.fromDate.formatted} → ${leave.toDate.formatted}',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text(leave.reason,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          DcBadge(label: leave.status.name),
        ]),
      );
}
