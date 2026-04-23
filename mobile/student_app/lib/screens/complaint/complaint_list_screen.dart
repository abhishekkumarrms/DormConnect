import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _complaintsProvider = FutureProvider<List<Complaint>>((ref) async {
  return ref.watch(complaintApiProvider).list();
});

class ComplaintListScreen extends ConsumerWidget {
  const ComplaintListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complaints = ref.watch(_complaintsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaints'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_complaintsProvider)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/complaints/create'),
        icon: const Icon(Icons.add),
        label: const Text('New'),
      ),
      body: complaints.when(
        loading: () => const DcShimmerList(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) => list.isEmpty
            ? const DcEmptyState(
                icon: Icons.report_problem_outlined,
                title: 'No complaints filed',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _ComplaintCard(c: list[i]),
              ),
      ),
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  final Complaint c;
  const _ComplaintCard({required this.c});

  @override
  Widget build(BuildContext context) => DcCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              DcBadge(label: c.category.name),
              const SizedBox(width: 8),
              DcBadge(label: c.status.name),
            ]),
            const SizedBox(height: 8),
            Text(c.description, style: const TextStyle(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(c.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 8),
            Text(c.createdAt?.formatted ?? '',
                style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
          ],
        ),
      );
}
