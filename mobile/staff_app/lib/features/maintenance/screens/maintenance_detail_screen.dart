import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../utils/role_permissions.dart';

final _maintDetailProvider =
    FutureProvider.autoDispose.family<MaintenanceRequest, String>(
        (ref, id) async =>
            ref.watch(maintenanceApiProvider).getById(id));

class MaintenanceDetailScreen extends ConsumerWidget {
  final String requestId;
  const MaintenanceDetailScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final role = user?.role ?? UserRole.warden;
    final async = ref.watch(_maintDetailProvider(requestId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(_maintDetailProvider(requestId)),
          ),
        ],
      ),
      body: async.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(message: e.toString()),
        data: (req) => SingleChildScrollView(
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
                          Text(req.title ?? req.category.name.snakeToTitle,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15)),
                          Text(req.category.name.snakeToTitle,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    DcStatusChip(status: req.status.name),
                  ]),
                  const Divider(height: 16),
                  if (req.reportedByName != null)
                    _Row('Reported by', req.reportedByName!),
                  if (req.roomNumber != null)
                    _Row('Room', req.roomNumber!),
                  if (req.location != null)
                    _Row('Location', req.location!),
                  _Row('Filed', req.createdAt?.formatted ?? '—'),
                  if (req.assignedToName != null)
                    _Row('Assigned to', req.assignedToName!),
                  if (req.scheduledAt != null)
                    _Row('Scheduled',
                        DateFormat('dd MMM yyyy HH:mm').format(req.scheduledAt!)),
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
                child: Text(req.description,
                    style: const TextStyle(height: 1.5)),
              ),

              if (req.fixedNote != null) ...[
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: AppColors.success, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(req.fixedNote!,
                              style: const TextStyle(height: 1.4))),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),
              if (RolePermissions.canManageMaintenance(role))
                _ActionButtons(requestId: requestId, req: req),
            ],
          ),
        ),
      ),
    );
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
            width: 100,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
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
  final String requestId;
  final MaintenanceRequest req;
  const _ActionButtons(
      {required this.requestId, required this.req});

  @override
  ConsumerState<_ActionButtons> createState() =>
      _ActionButtonsState();
}

class _ActionButtonsState extends ConsumerState<_ActionButtons> {
  List<String> get _actions => switch (widget.req.status) {
        MaintenanceStatus.submitted => ['Assign', 'Schedule'],
        MaintenanceStatus.assigned => ['Schedule', 'In Progress'],
        MaintenanceStatus.scheduled => ['In Progress'],
        MaintenanceStatus.inProgress => ['Mark Fixed', 'Cannot Fix'],
        _ => [],
      };

  void _showActionSheet(String action) {
    final noteCtrl = TextEditingController();
    final workerCtrl = TextEditingController(
        text: widget.req.assignedToName ?? '');
    DateTime? scheduledDt;

    DcBottomSheet.show(
      context,
      title: action,
      child: StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (action == 'Assign')
                DcTextField(
                    label: 'Worker Name',
                    controller: workerCtrl),
              if (action == 'Schedule') ...[
                OutlinedButton.icon(
                  onPressed: () async {
                    final dt = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now()
                          .add(const Duration(days: 30)),
                    );
                    if (dt != null) setS(() => scheduledDt = dt);
                  },
                  icon: const Icon(Icons.calendar_today_outlined,
                      size: 16),
                  label: Text(scheduledDt == null
                      ? 'Pick Date'
                      : scheduledDt!.formatted),
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48)),
                ),
              ],
              const SizedBox(height: 12),
              DcTextField(
                label: action == 'Mark Fixed'
                    ? 'Resolution Note (required)'
                    : 'Note (optional)',
                controller: noteCtrl,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DcButton(
                label: 'Confirm',
                onPressed: () async {
                  Navigator.pop(ctx);
                  try {
                    final data = <String, dynamic>{
                      'note': noteCtrl.text.trim(),
                      if (workerCtrl.text.trim().isNotEmpty)
                        'assigned_to': workerCtrl.text.trim(),
                      if (scheduledDt != null)
                        'scheduled_at':
                            scheduledDt!.toIso8601String(),
                    };
                    await ref.read(maintenanceApiProvider).action(
                        widget.requestId,
                        _toApiAction(action),
                        data);
                    ref.invalidate(
                        _maintDetailProvider(widget.requestId));
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
      ),
    );
  }

  String _toApiAction(String a) => switch (a) {
        'Assign' => 'assign',
        'Schedule' => 'schedule',
        'In Progress' => 'progress',
        'Mark Fixed' => 'fix',
        'Cannot Fix' => 'cannot_fix',
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
                onPressed: () => _showActionSheet(a),
                child: Text(a),
              ))
          .toList(),
    );
  }
}
