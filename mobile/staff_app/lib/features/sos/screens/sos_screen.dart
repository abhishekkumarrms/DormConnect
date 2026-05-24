import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _sosHistoryProvider = FutureProvider.autoDispose<List<SosAlert>>((ref) =>
    ref.watch(sosApiProvider).getHistory(limit: 50));

class SosScreen extends ConsumerWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(_sosHistoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Alerts'),
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_sosHistoryProvider),
          ),
        ],
      ),
      body: alertsAsync.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(_sosHistoryProvider),
        ),
        data: (alerts) {
          if (alerts.isEmpty) {
            return const DcEmptyState(
              icon: Icons.check_circle_outline,
              title: 'No SOS alerts',
              subtitle: 'All clear',
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(_sosHistoryProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: alerts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _SosCard(alert: alerts[i], ref: ref),
            ),
          );
        },
      ),
    );
  }
}

class _SosCard extends StatelessWidget {
  final SosAlert alert;
  final WidgetRef ref;
  const _SosCard({required this.alert, required this.ref});

  Color get _statusColor => switch (alert.status) {
        SosStatus.triggered => AppColors.error,
        SosStatus.responded => AppColors.warning,
        SosStatus.resolved => AppColors.success,
      };

  @override
  Widget build(BuildContext context) {
    return DcCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.sos_rounded, color: _statusColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                alert.studentName ?? 'Unknown Student',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
            DcStatusChip(status: alert.status.name),
          ]),
          if (alert.roomNumber != null || alert.hostelName != null) ...[
            const SizedBox(height: 4),
            Text(
              [alert.hostelName, 'Room ${alert.roomNumber}']
                  .whereType<String>()
                  .join(' · '),
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
          if (alert.message != null) ...[
            const SizedBox(height: 6),
            Text(alert.message!,
                style: const TextStyle(fontSize: 13)),
          ],
          const SizedBox(height: 8),
          Row(children: [
            Text(
              alert.triggeredAt != null
                  ? _timeAgo(alert.triggeredAt!)
                  : '',
              style: const TextStyle(color: AppColors.textTertiary, fontSize: 11),
            ),
            const Spacer(),
            if (alert.status == SosStatus.triggered)
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.error,
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onPressed: () => _respond(context),
                icon: const Icon(Icons.reply, size: 16),
                label: const Text('Respond', style: TextStyle(fontSize: 13)),
              ),
          ]),
        ],
      ),
    );
  }

  void _respond(BuildContext context) {
    final noteCtrl = TextEditingController();
    DcBottomSheet.show(
      context,
      title: 'Respond to SOS',
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DcTextField(
              label: 'Response note',
              controller: noteCtrl,
              maxLines: 3,
              hint: 'Describe your response action...',
            ),
            const SizedBox(height: 16),
            DcButton(
              label: 'Mark Responded',
              color: AppColors.warning,
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await ref.read(sosApiProvider).respond(alert.id, noteCtrl.text.trim());
                  ref.invalidate(_sosHistoryProvider);
                  if (context.mounted) DcSnackbar.success(context, 'SOS response recorded.');
                } catch (e) {
                  if (context.mounted) DcSnackbar.error(context, e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
