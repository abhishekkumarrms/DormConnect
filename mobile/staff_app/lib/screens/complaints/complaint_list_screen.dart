import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _staffComplaintsProvider =
    FutureProvider<List<Complaint>>((ref) async {
  return ref.watch(complaintApiProvider).list();
});

class ComplaintListScreen extends ConsumerWidget {
  const ComplaintListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complaints = ref.watch(_staffComplaintsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaints'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_staffComplaintsProvider)),
        ],
      ),
      body: complaints.when(
        loading: () => const DcShimmerList(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) => list.isEmpty
            ? const DcEmptyState(
                icon: Icons.report_problem_outlined,
                title: 'No complaints')
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) =>
                    _ComplaintCard(c: list[i], ref: ref),
              ),
      ),
    );
  }
}

class _ComplaintCard extends StatefulWidget {
  final Complaint c;
  final WidgetRef ref;
  const _ComplaintCard({required this.c, required this.ref});

  @override
  State<_ComplaintCard> createState() => _ComplaintCardState();
}

class _ComplaintCardState extends State<_ComplaintCard> {
  bool _expanded = false;

  Future<void> _action(String action) async {
    try {
      await widget.ref
          .read(complaintApiProvider)
          .action(widget.c.id, action, {});
      widget.ref.invalidate(_staffComplaintsProvider);
      if (mounted) DcSnackbar.success(context, 'Updated');
    } catch (e) {
      if (mounted) DcSnackbar.error(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    return DcCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        DcBadge(label: c.category.name),
                        const SizedBox(width: 8),
                        DcBadge(label: c.status.name),
                      ]),
                      const SizedBox(height: 6),
                      Text(c.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Icon(_expanded
                    ? Icons.expand_less
                    : Icons.expand_more),
              ],
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: 8),
            Text(c.description,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 12),
            Wrap(spacing: 8, children: [
              if (c.status == ComplaintStatus.submitted)
                ActionChip(
                    label: const Text('Accept'),
                    onPressed: () => _action('accept')),
              if (c.status == ComplaintStatus.accepted)
                ActionChip(
                    label: const Text('Start Work'),
                    onPressed: () => _action('start')),
              if (c.status == ComplaintStatus.inProgress)
                ActionChip(
                    label: const Text('Resolve'),
                    onPressed: () => _action('resolve')),
              if ([ComplaintStatus.submitted, ComplaintStatus.accepted]
                  .contains(c.status))
                ActionChip(
                    label: const Text('Reject'),
                    backgroundColor: AppColors.error.withOpacity(0.1),
                    onPressed: () => _action('reject')),
            ]),
          ],
        ],
      ),
    );
  }
}
