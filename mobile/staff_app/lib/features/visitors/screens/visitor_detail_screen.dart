import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/role_permissions.dart';

final _visitorDetailProvider =
    FutureProvider.autoDispose.family<Visitor, String>(
        (ref, id) async =>
            ref.watch(visitorApiProvider).list().then(
                (list) => list.firstWhere((v) => v.id == id)));

class VisitorDetailScreen extends ConsumerWidget {
  final String visitorId;
  const VisitorDetailScreen({super.key, required this.visitorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final role = user?.role ?? UserRole.warden;
    final async = ref.watch(_visitorDetailProvider(visitorId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitor Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(_visitorDetailProvider(visitorId)),
          ),
        ],
      ),
      body: async.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(message: e.toString()),
        data: (v) => SingleChildScrollView(
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
                          Text(v.visitorName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                          if (v.relation != null)
                            Text(v.relation!,
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13)),
                        ],
                      ),
                    ),
                    DcStatusChip(status: v.status.name),
                  ]),
                  const Divider(height: 20),
                  _Row('Phone', v.visitorPhone),
                  if (v.purpose != null)
                    _Row('Purpose', v.purpose!),
                  if (v.expectedAt != null)
                    _Row('Expected at',
                        DateFormat('dd MMM yyyy HH:mm')
                            .format(v.expectedAt!)),
                  if (v.expectedDurationHours != null)
                    _Row('Duration',
                        '${v.expectedDurationHours}h'),
                  if (v.entryTime != null)
                    _Row('Entry',
                        DateFormat('HH:mm').format(v.entryTime!)),
                  if (v.exitTime != null)
                    _Row('Exit',
                        DateFormat('HH:mm').format(v.exitTime!)),
                  _Row('Requested',
                      v.createdAt?.formatted ?? '—'),
                ]),
              ),
              const SizedBox(height: 16),

              // Call button
              OutlinedButton.icon(
                onPressed: () => _call(context, v.visitorPhone),
                icon: const Icon(Icons.call_outlined, size: 16),
                label: Text('Call ${v.visitorPhone}'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.success,
                  side: BorderSide(
                      color: AppColors.success.withOpacity(0.5)),
                  minimumSize: const Size(double.infinity, 44),
                ),
              ),

              const SizedBox(height: 20),
              if (RolePermissions.canManageVisitors(role))
                _ActionButtons(visitorId: visitorId, visitor: v),
            ],
          ),
        ),
      ),
    );
  }

  void _call(BuildContext context, String phone) async {
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

class _ActionButtons extends ConsumerWidget {
  final String visitorId;
  final Visitor visitor;
  const _ActionButtons(
      {required this.visitorId, required this.visitor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = switch (visitor.status) {
      VisitorStatus.requested => ['Approve', 'Reject'],
      VisitorStatus.approved => ['Log Entry'],
      VisitorStatus.inside => ['Log Exit'],
      _ => <String>[],
    };

    if (actions.isEmpty) return const SizedBox();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions
          .map((a) => OutlinedButton(
                onPressed: () => _doAction(context, ref, a),
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

  Color _color(String a) => switch (a) {
        'Approve' || 'Log Entry' || 'Log Exit' => AppColors.success,
        'Reject' => AppColors.error,
        _ => AppColors.primary,
      };

  Future<void> _doAction(
      BuildContext context, WidgetRef ref, String action) async {
    try {
      switch (action) {
        case 'Approve':
          await ref.read(visitorApiProvider).approve(visitorId);
        case 'Reject':
          await ref.read(visitorApiProvider).reject(visitorId);
        case 'Log Entry':
          await ref.read(visitorApiProvider).guardEntry(visitorId);
        case 'Log Exit':
          await ref.read(visitorApiProvider).guardExit(visitorId);
      }
      ref.invalidate(_visitorDetailProvider(visitorId));
      if (context.mounted) {
        DcSnackbar.success(context, '$action logged');
      }
    } catch (e) {
      if (context.mounted) {
        DcSnackbar.error(context, e.toString());
      }
    }
  }
}
