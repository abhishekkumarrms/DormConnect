import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _leavesProvider = FutureProvider<List<LeaveApplication>>((ref) async {
  return ref.watch(leaveApiProvider).list();
});

class LeaveListScreen extends ConsumerWidget {
  const LeaveListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaves = ref.watch(_leavesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Leaves'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_leavesProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/leaves/apply'),
        icon: const Icon(Icons.add),
        label: const Text('Apply'),
      ),
      body: leaves.when(
        loading: () => const DcShimmerList(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) => list.isEmpty
            ? const DcEmptyState(
                icon: Icons.beach_access_outlined,
                title: 'No leave applications',
                subtitle: 'Apply for a leave using the button below',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _LeaveCard(leave: list[i]),
              ),
      ),
    );
  }
}

class _LeaveCard extends StatelessWidget {
  final LeaveApplication leave;
  const _LeaveCard({required this.leave});

  @override
  Widget build(BuildContext context) {
    return DcCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  DcBadge(label: leave.leaveType.name),
                  const SizedBox(width: 8),
                  DcBadge(label: leave.status.name),
                ]),
                const SizedBox(height: 8),
                Text(
                  '${leave.fromDate.formatted} → ${leave.toDate.formatted}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(leave.reason,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
