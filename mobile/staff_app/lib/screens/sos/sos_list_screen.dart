import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _sosProvider = FutureProvider<List<SosAlert>>((ref) async {
  return ref.watch(sosApiProvider).getHistory();
});

class SosListScreen extends ConsumerWidget {
  const SosListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(_sosProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Alerts'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_sosProvider)),
        ],
      ),
      body: alerts.when(
        loading: () => const DcShimmerList(count: 3),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) => list.isEmpty
            ? const DcEmptyState(
                icon: Icons.health_and_safety_outlined,
                title: 'No SOS alerts',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _SosCard(alert: list[i], ref: ref),
              ),
      ),
    );
  }
}

class _SosCard extends StatelessWidget {
  final SosAlert alert;
  final WidgetRef ref;
  const _SosCard({required this.alert, required this.ref});

  Future<void> _respond(BuildContext context) async {
    final ctrl = TextEditingController();
    final note = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Respond to SOS'),
        content: TextField(
          controller: ctrl,
          decoration:
              const InputDecoration(hintText: 'Enter response note...'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: const Text('Respond')),
        ],
      ),
    );
    if (note == null || note.trim().isEmpty) return;
    try {
      await ref.read(sosApiProvider).respond(alert.id, note.trim());
      ref.invalidate(_sosProvider);
      if (context.mounted) DcSnackbar.success(context, 'Response recorded');
    } catch (e) {
      if (context.mounted) DcSnackbar.error(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = alert.status == SosStatus.triggered;
    return DcCard(
      color: isActive ? AppColors.error.withOpacity(0.05) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.sos,
                color: isActive ? AppColors.error : AppColors.textTertiary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(alert.studentName ?? '—',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            DcBadge(label: alert.status.name),
          ]),
          if (alert.roomNumber != null)
            Text('Room: ${alert.roomNumber}',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
          if (alert.message != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(alert.message!,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
            ),
          Text(alert.createdAt?.formattedWithTime ?? '',
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textTertiary)),
          if (isActive) ...[
            const SizedBox(height: 12),
            DcButton(
              label: 'Respond',
              color: AppColors.error,
              onPressed: () => _respond(context),
            ),
          ],
        ],
      ),
    );
  }
}
