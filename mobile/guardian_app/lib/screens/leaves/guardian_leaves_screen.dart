import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _guardianLeavesProvider =
    FutureProvider<List<LeaveApplication>>((ref) async {
  return ref.watch(leaveApiProvider).list();
});

class GuardianLeavesScreen extends ConsumerWidget {
  const GuardianLeavesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaves = ref.watch(_guardianLeavesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Applications'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_guardianLeavesProvider)),
        ],
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
                itemBuilder: (_, i) =>
                    _GuardianLeaveCard(leave: list[i], ref: ref),
              ),
      ),
    );
  }
}

class _GuardianLeaveCard extends StatefulWidget {
  final LeaveApplication leave;
  final WidgetRef ref;
  const _GuardianLeaveCard({required this.leave, required this.ref});

  @override
  State<_GuardianLeaveCard> createState() => _GuardianLeaveCardState();
}

class _GuardianLeaveCardState extends State<_GuardianLeaveCard> {
  bool _loading = false;

  Future<void> _confirm() async {
    setState(() => _loading = true);
    try {
      // Guardian confirms via token endpoint — for simplicity use ID
      await widget.ref
          .read(leaveApiProvider)
          .guardianConfirm(widget.leave.id);
      widget.ref.invalidate(_guardianLeavesProvider);
      if (mounted) DcSnackbar.success(context, 'Leave confirmed');
    } catch (e) {
      if (mounted) DcSnackbar.error(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.leave;
    final canConfirm = l.status == LeaveStatus.guardianContacted;
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
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
          if (l.destination != null) ...[
            const SizedBox(height: 4),
            Text('Destination: ${l.destination}',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textTertiary)),
          ],
          if (canConfirm) ...[
            const SizedBox(height: 12),
            DcButton(
              label: 'Confirm This Leave',
              onPressed: _confirm,
              isLoading: _loading,
              color: AppColors.success,
              icon: Icons.check_circle_outline,
            ),
          ],
        ],
      ),
    );
  }
}
