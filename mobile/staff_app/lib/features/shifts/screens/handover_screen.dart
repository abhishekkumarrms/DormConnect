import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Provider hitting the generic notes endpoint
final _handoverLogProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>(
        (ref, hostelId) async {
  final resp = await ref
      .watch(apiClientProvider)
      .get('/api/v1/handover', params: {'hostel_id': hostelId});
  return (resp.data as List<dynamic>).cast<Map<String, dynamic>>();
});

class HandoverScreen extends ConsumerStatefulWidget {
  const HandoverScreen({super.key});

  @override
  ConsumerState<HandoverScreen> createState() =>
      _HandoverScreenState();
}

class _HandoverScreenState extends ConsumerState<HandoverScreen> {
  final _noteCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _noteCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final hostelId = user?.hostelId ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Handover'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(_handoverLogProvider(hostelId)),
          ),
        ],
      ),
      body: Column(children: [
        // Handover entry form
        DcCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.swap_horiz_rounded,
                    color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Log Handover — ${DateFormat('dd MMM HH:mm').format(DateTime.now())}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ]),
              const SizedBox(height: 12),
              DcTextField(
                label: 'Handing over to',
                controller: _toCtrl,
                hint: 'Staff name',
              ),
              const SizedBox(height: 8),
              DcTextField(
                label: 'Handover note',
                controller: _noteCtrl,
                maxLines: 3,
                hint:
                    'Pending tasks, issues, students out, anything to note…',
              ),
              const SizedBox(height: 12),
              DcButton(
                label: _loading ? 'Logging…' : 'Log Handover',
                onPressed: _loading
                    ? null
                    : () => _log(context, hostelId, user?.name ?? ''),
              ),
            ],
          ),
        ),

        // Log
        Expanded(
          child: hostelId.isEmpty
              ? const DcEmptyState(
                  icon: Icons.home_work_outlined,
                  title: 'No hostel assigned')
              : _LogList(hostelId: hostelId),
        ),
      ]),
    );
  }

  Future<void> _log(
      BuildContext context, String hostelId, String staffName) async {
    if (_toCtrl.text.trim().isEmpty) {
      DcSnackbar.error(context, 'Enter handover recipient');
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(apiClientProvider).post('/api/v1/handover', data: {
        'hostel_id': hostelId,
        'from_staff': staffName,
        'to_staff': _toCtrl.text.trim(),
        'note': _noteCtrl.text.trim(),
      });
      _toCtrl.clear();
      _noteCtrl.clear();
      ref.invalidate(_handoverLogProvider(hostelId));
      if (context.mounted) {
        DcSnackbar.success(context, 'Handover logged');
      }
    } catch (e) {
      if (context.mounted) DcSnackbar.error(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _LogList extends ConsumerWidget {
  final String hostelId;
  const _LogList({required this.hostelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_handoverLogProvider(hostelId));
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) => DcErrorState(message: e.toString()),
      data: (log) {
        if (log.isEmpty) {
          return const DcEmptyState(
              icon: Icons.history_toggle_off_rounded,
              title: 'No handover entries yet');
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: log.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final entry = log[i];
            DateTime? ts;
            try {
              ts = DateTime.parse(
                  entry['created_at'] as String? ?? '');
            } catch (_) {}
            return DcCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.swap_horiz_rounded,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      '${entry['from_staff'] ?? '?'} → ${entry['to_staff'] ?? '?'}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                    const Spacer(),
                    if (ts != null)
                      Text(
                        DateFormat('dd MMM HH:mm').format(ts),
                        style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 11),
                      ),
                  ]),
                  if ((entry['note'] as String?)?.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        entry['note'] as String,
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            height: 1.4),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
