import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final _leaveDetailProvider =
    FutureProvider.autoDispose.family<LeaveApplication, String>((ref, id) async {
  final list = await ref.read(leaveApiProvider).list();
  return list.firstWhere((l) => l.id == id);
});

class LeaveDetailScreen extends ConsumerWidget {
  final String leaveId;
  const LeaveDetailScreen({super.key, required this.leaveId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leave = ref.watch(_leaveDetailProvider(leaveId));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Leave Details',
            style: TextStyle(
                color: Color(0xFF0F172A), fontWeight: FontWeight.w700)),
      ),
      body: leave.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (l) => _LeaveDetailBody(leave: l),
      ),
    );
  }
}

class _LeaveDetailBody extends ConsumerStatefulWidget {
  final LeaveApplication leave;
  const _LeaveDetailBody({required this.leave});

  @override
  ConsumerState<_LeaveDetailBody> createState() => _LeaveDetailBodyState();
}

class _LeaveDetailBodyState extends ConsumerState<_LeaveDetailBody> {
  bool _loading = false;

  Future<void> _confirm() async {
    setState(() => _loading = true);
    try {
      await ref.read(leaveApiProvider).guardianConfirm(widget.leave.id);
      ref.invalidate(_leaveDetailProvider(widget.leave.id));
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
    final isPending = l.status == LeaveStatus.guardianContacted;
    final fmt = DateFormat('d MMM yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status header card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isPending
                  ? const Color(0xFFFEF9C3)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: isPending
                      ? const Color(0xFFFCD34D)
                      : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                if (isPending)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.pending_outlined,
                          color: Color(0xFFF59E0B), size: 18),
                      const SizedBox(width: 6),
                      const Text(
                        'Your Confirmation Needed',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF92400E)),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                Text(
                  '${fmt.format(l.fromDate)} → ${fmt.format(l.toDate)}',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800),
                ),
                Text(
                  '${l.toDate.difference(l.fromDate).inDays + 1} days',
                  style: const TextStyle(
                      color: Color(0xFF6B7280), fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Info rows
          _InfoCard(children: [
            _InfoRow(label: 'Leave Type', value: l.leaveType.name),
            _InfoRow(label: 'Status', value: l.status.name),
            _InfoRow(label: 'Reason', value: l.reason),
            if (l.destination != null)
              _InfoRow(label: 'Destination', value: l.destination!),
            if (l.contactDuringLeave != null)
              _InfoRow(
                  label: 'Contact During Leave',
                  value: l.contactDuringLeave!),
            if (l.createdAt != null)
              _InfoRow(
                  label: 'Applied On',
                  value: DateFormat('d MMM yyyy, h:mm a')
                      .format(l.createdAt!)),
          ]),

          if (l.caretakerNote != null) ...[
            const SizedBox(height: 12),
            _InfoCard(children: [
              _InfoRow(
                  label: 'Caretaker Note', value: l.caretakerNote!),
            ]),
          ],

          const SizedBox(height: 16),

          // Status timeline
          const Text('Status Timeline',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          _StatusTimeline(status: l.status, guardianConfirmed: l.guardianConfirmed),

          // Confirm button
          if (isPending && !l.guardianConfirmed) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _confirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check_circle_rounded),
                label: const Text('Confirm This Leave',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],

          if (l.guardianConfirmed)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(children: [
                Icon(Icons.check_circle_rounded,
                    color: Color(0xFF10B981), size: 18),
                SizedBox(width: 8),
                Text('You have confirmed this leave',
                    style: TextStyle(
                        color: Color(0xFF166534),
                        fontWeight: FontWeight.w600)),
              ]),
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 140,
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF6B7280))),
            ),
            Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
}

class _StatusTimeline extends StatelessWidget {
  final LeaveStatus status;
  final bool guardianConfirmed;
  const _StatusTimeline(
      {required this.status, required this.guardianConfirmed});

  @override
  Widget build(BuildContext context) {
    final steps = [
      (
        label: 'Submitted',
        done: true,
        icon: Icons.send_rounded,
      ),
      (
        label: 'Under Review',
        done: status.index >= LeaveStatus.underReview.index,
        icon: Icons.manage_search_rounded,
      ),
      (
        label: 'Guardian Contacted',
        done: status.index >= LeaveStatus.guardianContacted.index,
        icon: Icons.phone_outlined,
      ),
      (
        label: 'Guardian Confirmed',
        done: guardianConfirmed,
        icon: Icons.verified_rounded,
      ),
      (
        label: status == LeaveStatus.approved ? 'Approved' : 'Decision',
        done: status == LeaveStatus.approved || status == LeaveStatus.rejected,
        icon: status == LeaveStatus.rejected
            ? Icons.cancel_outlined
            : Icons.check_circle_rounded,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: steps.asMap().entries.map((e) {
          final idx = e.key;
          final step = e.value;
          final isLast = idx == steps.length - 1;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: step.done
                          ? const Color(0xFF10B981)
                          : const Color(0xFFE2E8F0),
                    ),
                    child: Icon(
                      step.icon,
                      size: 14,
                      color: step.done ? Colors.white : const Color(0xFF9CA3AF),
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 24,
                      color: step.done
                          ? const Color(0xFF10B981)
                          : const Color(0xFFE2E8F0),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 20),
                child: Text(
                  step.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: step.done ? FontWeight.w600 : FontWeight.w400,
                    color: step.done
                        ? const Color(0xFF0F172A)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
