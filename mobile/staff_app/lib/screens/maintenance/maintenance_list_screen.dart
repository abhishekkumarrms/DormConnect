import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _maintenanceProvider =
    FutureProvider<List<MaintenanceRequest>>((ref) async {
  return ref.watch(maintenanceApiProvider).list();
});

class MaintenanceListScreen extends ConsumerWidget {
  const MaintenanceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(_maintenanceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_maintenanceProvider)),
        ],
      ),
      body: requests.when(
        loading: () => const DcShimmerList(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) => list.isEmpty
            ? const DcEmptyState(
                icon: Icons.build_outlined, title: 'No maintenance requests')
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _MaintCard(m: list[i], ref: ref),
              ),
      ),
    );
  }
}

class _MaintCard extends StatelessWidget {
  final MaintenanceRequest m;
  final WidgetRef ref;
  const _MaintCard({required this.m, required this.ref});

  Future<void> _action(BuildContext context, String action) async {
    try {
      await ref.read(maintenanceApiProvider).action(m.id, action, {});
      ref.invalidate(_maintenanceProvider);
      if (context.mounted) DcSnackbar.success(context, 'Updated');
    } catch (e) {
      if (context.mounted) DcSnackbar.error(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => DcCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              DcBadge(label: m.category.name),
              const SizedBox(width: 8),
              DcBadge(label: m.status.name),
            ]),
            const SizedBox(height: 8),
            Text(m.title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(m.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
            if (m.location != null) ...[
              const SizedBox(height: 4),
              Text('📍 ${m.location}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textTertiary)),
            ],
            const SizedBox(height: 12),
            Wrap(spacing: 8, children: [
              if (m.status == MaintenanceStatus.submitted)
                ActionChip(
                    label: const Text('Assign'),
                    onPressed: () => _action(context, 'assign')),
              if (m.status == MaintenanceStatus.assigned)
                ActionChip(
                    label: const Text('Schedule'),
                    onPressed: () => _action(context, 'schedule')),
              if (m.status == MaintenanceStatus.scheduled)
                ActionChip(
                    label: const Text('Start'),
                    onPressed: () => _action(context, 'start')),
              if (m.status == MaintenanceStatus.inProgress)
                ActionChip(
                    label: const Text('Mark Fixed'),
                    backgroundColor: AppColors.success.withOpacity(0.1),
                    onPressed: () => _action(context, 'complete')),
            ]),
          ],
        ),
      );
}
