import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _leaveFilterProvider = StateProvider<String?>((ref) => null);

final _staffLeavesProvider = FutureProvider<List<LeaveApplication>>((ref) async {
  final filter = ref.watch(_leaveFilterProvider);
  return ref.watch(leaveApiProvider).list(status: filter);
});

class LeaveListScreen extends ConsumerWidget {
  const LeaveListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaves = ref.watch(_staffLeavesProvider);
    final filter = ref.watch(_leaveFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Applications'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_staffLeavesProvider)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [null, 'PENDING', 'WARDEN_APPROVED', 'APPROVED', 'REJECTED']
                  .map((f) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(f ?? 'All'),
                          selected: filter == f,
                          onSelected: (_) =>
                              ref.read(_leaveFilterProvider.notifier).state = f,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      body: leaves.when(
        loading: () => const DcShimmerList(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) => list.isEmpty
            ? const DcEmptyState(
                icon: Icons.beach_access_outlined,
                title: 'No leave applications',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _LeaveCard(leave: list[i], ref: ref),
              ),
      ),
    );
  }
}

class _LeaveCard extends StatefulWidget {
  final LeaveApplication leave;
  final WidgetRef ref;
  const _LeaveCard({required this.leave, required this.ref});

  @override
  State<_LeaveCard> createState() => _LeaveCardState();
}

class _LeaveCardState extends State<_LeaveCard> {
  bool _loading = false;

  Future<void> _action(String action) async {
    setState(() => _loading = true);
    try {
      await widget.ref.read(leaveApiProvider).action(
          widget.leave.id, action, {});
      widget.ref.invalidate(_staffLeavesProvider);
      if (mounted) {
        DcSnackbar.success(context, 'Leave ${action}d');
      }
    } catch (e) {
      if (mounted) DcSnackbar.error(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.leave;
    return DcCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            DcBadge(label: l.leaveType.name),
            const SizedBox(width: 8),
            DcBadge(label: l.status.name),
          ]),
          const SizedBox(height: 8),
          Text('${l.fromDate.formatted} → ${l.toDate.formatted}',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(l.reason,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
          if (l.status == LeaveStatus.submitted) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : Row(children: [
                          Expanded(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.success),
                              onPressed: () => _action('approve'),
                              child: const Text('Approve'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _action('reject'),
                              child: const Text('Reject'),
                            ),
                          ),
                        ]),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
