import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/role_permissions.dart';

final _leaveDetailProvider =
    FutureProvider.autoDispose.family<LeaveApplication, String>(
        (ref, id) async =>
            ref.watch(leaveApiProvider).getById(id));

class LeaveDetailScreen extends ConsumerWidget {
  final String leaveId;
  const LeaveDetailScreen({super.key, required this.leaveId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final role = user?.role ?? UserRole.warden;
    final async = ref.watch(_leaveDetailProvider(leaveId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(_leaveDetailProvider(leaveId)),
          ),
        ],
      ),
      body: async.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(message: e.toString()),
        data: (leave) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DcCard(
                child: Column(children: [
                  Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            leave.leaveType.name.snakeToTitle,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          Text(
                            leave.studentName ?? 'Student',
                            style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    DcStatusChip(status: leave.status.name),
                  ]),
                  const Divider(height: 20),
                  _Row('Dates',
                      '${DateFormat('dd MMM yyyy').format(leave.fromDate)} – ${DateFormat('dd MMM yyyy').format(leave.toDate)}'),
                  _Row('Days',
                      '${leave.toDate.difference(leave.fromDate).inDays + 1}'),
                  if (leave.destination != null)
                    _Row('Destination', leave.destination!),
                  if (leave.contactDuringLeave != null)
                    _Row('Contact', leave.contactDuringLeave!),
                  _Row('Filed',
                      leave.createdAt?.formatted ?? '—'),
                  _Row('Guardian Confirmed',
                      leave.guardianConfirmed ? 'Yes' : 'No'),
                ]),
              ),
              const SizedBox(height: 12),

              // Reason
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(leave.reason,
                    style: const TextStyle(height: 1.5)),
              ),

              if (leave.caretakerNote != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.notes_rounded,
                        size: 14, color: AppColors.info),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(leave.caretakerNote!,
                            style: const TextStyle(fontSize: 13))),
                  ]),
                ),
              ],

              if (leave.guardianConfirmed) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.success.withOpacity(0.3)),
                  ),
                  child: const Row(children: [
                    Icon(Icons.verified_outlined,
                        size: 14, color: AppColors.success),
                    SizedBox(width: 8),
                    Text('Guardian has confirmed this leave',
                        style: TextStyle(
                            fontSize: 13,
                            color: AppColors.success)),
                  ]),
                ),
              ],

              // Call Guardian button
              if (leave.contactDuringLeave != null) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _callGuardian(
                      context, leave.contactDuringLeave!),
                  icon: const Icon(Icons.call_outlined, size: 16),
                  label: Text(
                      'Call Guardian (${leave.contactDuringLeave})'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.success,
                    side: BorderSide(
                        color: AppColors.success.withOpacity(0.5)),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                ),
              ],

              const SizedBox(height: 20),
              if (RolePermissions.canActOnLeaves(role))
                _ActionButtons(leaveId: leaveId, leave: leave),
            ],
          ),
        ),
      ),
    );
  }

  void _callGuardian(BuildContext context, String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        DcSnackbar.error(context, 'Cannot launch dialer');
      }
    }
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ]),
      );
}

class _ActionButtons extends ConsumerStatefulWidget {
  final String leaveId;
  final LeaveApplication leave;
  const _ActionButtons({required this.leaveId, required this.leave});

  @override
  ConsumerState<_ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends ConsumerState<_ActionButtons> {
  List<String> get _actions => switch (widget.leave.status) {
        LeaveStatus.submitted => ['Review', 'Reject'],
        LeaveStatus.underReview => [
            'Contact Guardian',
            'Approve',
            'Reject'
          ],
        LeaveStatus.guardianContacted => ['Approve', 'Reject'],
        _ => [],
      };

  Color _color(String a) => switch (a) {
        'Approve' => AppColors.success,
        'Reject' => AppColors.error,
        _ => AppColors.primary,
      };

  void _doAction(BuildContext context, String action) {
    final noteCtrl = TextEditingController();
    DcBottomSheet.show(
      context,
      title: action,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DcTextField(
              label: action == 'Reject'
                  ? 'Reason (required)'
                  : 'Note (optional)',
              controller: noteCtrl,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DcButton(
              label: 'Confirm $action',
              color: _color(action),
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await ref.read(leaveApiProvider).action(
                      widget.leaveId,
                      _toApiAction(action),
                      {'note': noteCtrl.text.trim()});
                  ref.invalidate(
                      _leaveDetailProvider(widget.leaveId));
                  if (context.mounted) {
                    DcSnackbar.success(context, '$action applied');
                  }
                } catch (e) {
                  if (context.mounted) {
                    DcSnackbar.error(context, e.toString());
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _toApiAction(String a) => switch (a) {
        'Review' => 'review',
        'Contact Guardian' => 'contact_guardian',
        'Approve' => 'approve',
        'Reject' => 'reject',
        _ => a.toLowerCase(),
      };

  @override
  Widget build(BuildContext context) {
    if (_actions.isEmpty) return const SizedBox();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _actions
          .map((a) => OutlinedButton(
                onPressed: () => _doAction(context, a),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _color(a),
                  side: BorderSide(
                      color: _color(a).withOpacity(0.5)),
                ),
                child: Text(a),
              ))
          .toList(),
    );
  }
}
