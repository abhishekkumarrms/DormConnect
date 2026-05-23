import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _myLeavesAllProvider =
    FutureProvider<List<LeaveApplication>>((ref) async =>
        ref.watch(leaveApiProvider).list(limit: 50));

class LeavesScreen extends ConsumerWidget {
  const LeavesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leavesAsync = ref.watch(_myLeavesAllProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Leaves'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: AppColors.secondary,
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'History'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.go('/leave/new'),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Apply Leave'),
          backgroundColor: AppColors.primary,
        ),
        body: leavesAsync.when(
          loading: () => const DcLoading(),
          error: (e, _) => DcErrorState(
              message: e.toString(),
              onRetry: () => ref.invalidate(_myLeavesAllProvider)),
          data: (list) {
            final now = DateTime.now();
            final active = list
                .where((l) =>
                    l.status != LeaveStatus.rejected &&
                    l.toDate.isAfter(now))
                .toList();
            final history = list
                .where((l) =>
                    l.status == LeaveStatus.rejected ||
                    l.toDate.isBefore(now))
                .toList();
            return TabBarView(
              children: [
                _LeaveList(
                    leaves: active,
                    emptyMessage: 'No active leave applications'),
                _LeaveList(
                    leaves: history, emptyMessage: 'No leave history'),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LeaveList extends StatelessWidget {
  final List<LeaveApplication> leaves;
  final String emptyMessage;
  const _LeaveList(
      {required this.leaves, required this.emptyMessage});

  @override
  Widget build(BuildContext context) => leaves.isEmpty
      ? DcEmptyState(
          icon: Icons.beach_access_outlined, title: emptyMessage)
      : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: leaves.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) => _LeaveCard(leave: leaves[i]),
        );
}

class _LeaveCard extends StatelessWidget {
  final LeaveApplication leave;
  const _LeaveCard({required this.leave});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.go('/leave/${leave.id}'),
        child: DcCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                DcBadge(label: leave.leaveType.name),
                const SizedBox(width: 8),
                DcStatusChip(status: leave.status.name),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textTertiary, size: 18),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  '${leave.fromDate.formatted} → ${leave.toDate.formatted}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ]),
              const SizedBox(height: 4),
              Text(leave.reason,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
              if (leave.guardianConfirmed) ...[
                const SizedBox(height: 6),
                const Row(children: [
                  Icon(Icons.check_circle_rounded,
                      size: 13, color: AppColors.success),
                  SizedBox(width: 4),
                  Text('Guardian confirmed',
                      style: TextStyle(
                          color: AppColors.success, fontSize: 11)),
                ]),
              ],
            ],
          ),
        ),
      );
}
