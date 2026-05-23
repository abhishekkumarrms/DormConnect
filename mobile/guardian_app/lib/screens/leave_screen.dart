import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final _leavesProvider =
    FutureProvider.autoDispose<List<LeaveApplication>>((ref) async {
  return ref.read(leaveApiProvider).list();
});

class LeaveScreen extends ConsumerWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaves = ref.watch(_leavesProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Leave Applications',
            style: TextStyle(
                color: Color(0xFF0F172A), fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0F172A)),
            onPressed: () => ref.invalidate(_leavesProvider),
          ),
        ],
      ),
      body: leaves.when(
        loading: () =>
            const Padding(padding: EdgeInsets.all(16), child: DcShimmerList()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) {
          final pending = list
              .where((l) => l.status == LeaveStatus.guardianContacted)
              .toList();
          final rest = list
              .where((l) => l.status != LeaveStatus.guardianContacted)
              .toList();

          if (list.isEmpty) {
            return const DcEmptyState(
              icon: Icons.beach_access_outlined,
              title: 'No leave applications',
              subtitle: 'Leave requests will appear here',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (pending.isNotEmpty) ...[
                _SectionLabel(
                  label: 'Awaiting Your Confirmation',
                  color: const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 8),
                ...pending.map((l) => _LeaveCard(leave: l, isPending: true)),
                const SizedBox(height: 20),
              ],
              if (rest.isNotEmpty) ...[
                const _SectionLabel(label: 'History'),
                const SizedBox(height: 8),
                ...rest.map((l) => _LeaveCard(leave: l)),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color? color;
  const _SectionLabel({required this.label, this.color});

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color ?? const Color(0xFF334155)),
      );
}

class _LeaveCard extends ConsumerStatefulWidget {
  final LeaveApplication leave;
  final bool isPending;
  const _LeaveCard({required this.leave, this.isPending = false});

  @override
  ConsumerState<_LeaveCard> createState() => _LeaveCardState();
}

class _LeaveCardState extends ConsumerState<_LeaveCard> {
  bool _loading = false;

  Future<void> _confirm() async {
    setState(() => _loading = true);
    try {
      await ref.read(leaveApiProvider).guardianConfirm(widget.leave.id);
      ref.invalidate(_leavesProvider);
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
    return GestureDetector(
      onTap: () => context.push('/leaves/${l.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: widget.isPending
                  ? const Color(0xFFFCD34D)
                  : const Color(0xFFE2E8F0),
              width: widget.isPending ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              _LeaveTypeBadge(type: l.leaveType),
              const SizedBox(width: 8),
              _StatusBadge(status: l.status),
              const Spacer(),
              const Icon(Icons.chevron_right_rounded,
                  size: 18, color: Color(0xFF9CA3AF)),
            ]),
            const SizedBox(height: 8),
            Text(
              '${DateFormat('d MMM').format(l.fromDate)} → ${DateFormat('d MMM yyyy').format(l.toDate)}',
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              l.reason,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF6B7280)),
            ),

            // Confirm button only for pending
            if (widget.isPending) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _confirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Confirm This Leave',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LeaveTypeBadge extends StatelessWidget {
  final LeaveType type;
  const _LeaveTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          type.name,
          style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF8B5CF6),
              fontWeight: FontWeight.w600),
        ),
      );
}

class _StatusBadge extends StatelessWidget {
  final LeaveStatus status;
  const _StatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case LeaveStatus.approved:
        return const Color(0xFF10B981);
      case LeaveStatus.rejected:
        return const Color(0xFFEF4444);
      case LeaveStatus.guardianContacted:
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: _color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: _color.withOpacity(0.3)),
        ),
        child: Text(
          status.name,
          style: TextStyle(
              fontSize: 11,
              color: _color,
              fontWeight: FontWeight.w600),
        ),
      );
}
