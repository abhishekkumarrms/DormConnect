import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _leaveDetailProvider =
    FutureProvider.family<LeaveApplication, String>((ref, id) async =>
        ref.watch(leaveApiProvider).getById(id));

class LeaveDetailScreen extends ConsumerWidget {
  final String leaveId;
  const LeaveDetailScreen({super.key, required this.leaveId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaveAsync = ref.watch(_leaveDetailProvider(leaveId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_leaveDetailProvider(leaveId)),
          ),
        ],
      ),
      body: leaveAsync.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(message: e.toString()),
        data: (leave) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card
              DcCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      DcBadge(label: leave.leaveType.name),
                      const SizedBox(width: 8),
                      DcStatusChip(status: leave.status.name),
                    ]),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Duration',
                      value:
                          '${leave.fromDate.formatted} → ${leave.toDate.formatted}',
                    ),
                    if (leave.destination != null)
                      _InfoRow(
                        icon: Icons.place_outlined,
                        label: 'Destination',
                        value: leave.destination!,
                      ),
                    _InfoRow(
                      icon: Icons.event_note_outlined,
                      label: 'Applied On',
                      value: leave.createdAt?.formatted ?? '—',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Reason
              const Text('Reason',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(leave.reason,
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.5)),
              ),
              const SizedBox(height: 16),

              // Status timeline
              const Text('Status Timeline',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 12),
              _StatusTimeline(status: leave.status),
              const SizedBox(height: 16),

              // Caretaker note
              if (leave.caretakerNote != null) ...[
                const Text('Caretaker Note',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Text(leave.caretakerNote!,
                      style: const TextStyle(height: 1.5)),
                ),
                const SizedBox(height: 16),
              ],

              // Guardian confirmation
              DcCard(
                child: Row(children: [
                  Icon(
                    leave.guardianConfirmed
                        ? Icons.check_circle_rounded
                        : Icons.pending_rounded,
                    color: leave.guardianConfirmed
                        ? AppColors.success
                        : AppColors.textTertiary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    leave.guardianConfirmed
                        ? 'Guardian has confirmed'
                        : 'Awaiting guardian confirmation',
                    style: TextStyle(
                      color: leave.guardianConfirmed
                          ? AppColors.success
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  final LeaveStatus status;
  const _StatusTimeline({required this.status});

  static const _steps = [
    (status: LeaveStatus.submitted, label: 'Submitted'),
    (status: LeaveStatus.underReview, label: 'Under Review'),
    (status: LeaveStatus.guardianContacted, label: 'Guardian Contacted'),
    (status: LeaveStatus.approved, label: 'Approved'),
  ];

  int get _currentIndex {
    if (status == LeaveStatus.rejected) return -1;
    return _steps.indexWhere((s) => s.status == status);
  }

  @override
  Widget build(BuildContext context) {
    if (status == LeaveStatus.rejected) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(children: [
          Icon(Icons.cancel_rounded, color: AppColors.error, size: 20),
          SizedBox(width: 8),
          Text('Application Rejected',
              style: TextStyle(
                  color: AppColors.error, fontWeight: FontWeight.w600)),
        ]),
      );
    }
    return Column(
      children: List.generate(_steps.length, (i) {
        final step = _steps[i];
        final done = i <= _currentIndex;
        final active = i == _currentIndex;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done
                      ? AppColors.primary
                      : AppColors.surfaceVariant,
                  border: Border.all(
                      color: done
                          ? AppColors.primary
                          : AppColors.border),
                ),
                alignment: Alignment.center,
                child: done
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 14)
                    : null,
              ),
              if (i < _steps.length - 1)
                Container(
                    width: 2,
                    height: 28,
                    color: done
                        ? AppColors.primary
                        : AppColors.border),
            ]),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 28),
              child: Text(step.label,
                  style: TextStyle(
                    fontWeight: active
                        ? FontWeight.w700
                        : FontWeight.normal,
                    color: done
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  )),
            ),
          ],
        );
      }),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.end,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ]),
      );
}
