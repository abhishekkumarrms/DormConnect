import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/role_permissions.dart';

final _complaintDetailProvider =
    FutureProvider.autoDispose.family<Complaint, String>((ref, id) async =>
        ref.watch(complaintApiProvider).getById(id));

class ComplaintDetailScreen extends ConsumerWidget {
  final String complaintId;
  const ComplaintDetailScreen({super.key, required this.complaintId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final role = user?.role ?? UserRole.warden;
    final async = ref.watch(_complaintDetailProvider(complaintId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(_complaintDetailProvider(complaintId)),
          ),
        ],
      ),
      body: async.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(message: e.toString()),
        data: (c) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DcCard(
                child: Column(children: [
                  Row(children: [
                    Text(c.category.name.snakeToTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    const Spacer(),
                    DcStatusChip(status: c.status.name),
                  ]),
                  const SizedBox(height: 8),
                  if (c.studentName != null)
                    Row(children: [
                      const Icon(Icons.person_outlined,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        '${c.studentName}  ·  Room ${c.roomNumber ?? '—'}',
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12),
                      ),
                    ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.schedule_outlined,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(c.createdAt?.formatted ?? '',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ]),
                  if (c.assignedToName != null) ...[
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.assignment_ind_outlined,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text('Assigned: ${c.assignedToName}',
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12)),
                    ]),
                  ],
                ]),
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(c.description,
                    style: const TextStyle(height: 1.5)),
              ),

              if (c.photoUrl != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(c.photoUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox()),
                ),
              ],

              if (c.updates.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Updates',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 8),
                ...c.updates.map((u) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(u.updatedByName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                              const Spacer(),
                              if (u.newStatus != null)
                                DcStatusChip(status: u.newStatus!),
                            ]),
                            if (u.note != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(u.note!,
                                    style: const TextStyle(
                                        fontSize: 12)),
                              ),
                          ],
                        ),
                      ),
                    )),
              ],

              const SizedBox(height: 20),
              if (RolePermissions.canActOnComplaints(role))
                _ActionButtons(
                    complaintId: complaintId,
                    status: c.status,
                    role: role),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  final String complaintId;
  final ComplaintStatus status;
  final UserRole role;
  const _ActionButtons({
    required this.complaintId,
    required this.status,
    required this.role,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = _actionsFor(status, role);
    if (actions.isEmpty) return const SizedBox();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions.map((a) => OutlinedButton(
        onPressed: () => _showActionSheet(context, ref, a),
        style: OutlinedButton.styleFrom(
          foregroundColor: _actionColor(a),
          side: BorderSide(color: _actionColor(a).withOpacity(0.5)),
        ),
        child: Text(a),
      )).toList(),
    );
  }

  List<String> _actionsFor(ComplaintStatus s, UserRole r) {
    if (r == UserRole.caretaker) {
      return switch (s) {
        ComplaintStatus.submitted => ['Accept', 'Reject'],
        ComplaintStatus.accepted => ['In Progress', 'Resolve', 'Escalate'],
        ComplaintStatus.inProgress => ['Resolve', 'Escalate'],
        _ => [],
      };
    }
    if (r == UserRole.asstWarden) {
      return switch (s) {
        ComplaintStatus.escalated => ['Resolve', 'Escalate'],
        _ => [],
      };
    }
    return [];
  }

  Color _actionColor(String action) {
    return switch (action) {
      'Accept' || 'Resolve' => AppColors.success,
      'Reject' => AppColors.error,
      'Escalate' => AppColors.warning,
      _ => AppColors.primary,
    };
  }

  void _showActionSheet(
      BuildContext context, WidgetRef ref, String action) {
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
              label: action == 'Reject' || action == 'Resolve'
                  ? 'Note (required)'
                  : 'Note (optional)',
              controller: noteCtrl,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DcButton(
              label: 'Confirm $action',
              color: _actionColor(action),
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final apiAction = _toApiAction(action);
                  await ref.read(complaintApiProvider).updateAction(
                      complaintId,
                      apiAction,
                      {'note': noteCtrl.text.trim()});
                  ref.invalidate(_complaintDetailProvider(complaintId));
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

  String _toApiAction(String action) => switch (action) {
        'Accept' => 'accept',
        'Reject' => 'reject',
        'In Progress' => 'progress',
        'Resolve' => 'resolve',
        'Escalate' => 'escalate',
        _ => action.toLowerCase(),
      };
}
