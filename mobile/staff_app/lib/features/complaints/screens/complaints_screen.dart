import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _complaintsProvider =
    FutureProvider.autoDispose.family<List<Complaint>, String?>(
        (ref, status) async =>
            ref.watch(complaintApiProvider).list(status: status, limit: 100));

class ComplaintsScreen extends ConsumerStatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  ConsumerState<ComplaintsScreen> createState() =>
      _ComplaintsScreenState();
}

class _ComplaintsScreenState extends ConsumerState<ComplaintsScreen> {
  String? _statusFilter;

  static const _filters = [
    ('All', null),
    ('Pending', 'submitted'),
    ('Accepted', 'accepted'),
    ('In Progress', 'inProgress'),
    ('Resolved', 'resolved'),
    ('Escalated', 'escalated'),
  ];

  @override
  Widget build(BuildContext context) {
    final complaintsAsync = ref.watch(_complaintsProvider(_statusFilter));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaints'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(_complaintsProvider(_statusFilter)),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              children: _filters
                  .map((f) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(f.$1),
                          selected: _statusFilter == f.$2,
                          selectedColor:
                              AppColors.primary.withOpacity(0.15),
                          onSelected: (_) =>
                              setState(() => _statusFilter = f.$2),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: complaintsAsync.when(
              loading: () => const DcLoading(),
              error: (e, _) => DcErrorState(
                  message: e.toString(),
                  onRetry: () => ref.invalidate(
                      _complaintsProvider(_statusFilter))),
              data: (list) {
                if (list.isEmpty) {
                  return const DcEmptyState(
                      icon: Icons.check_circle_outline,
                      title: 'No complaints found');
                }
                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(_complaintsProvider(_statusFilter)),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 8),
                    itemBuilder: (_, i) =>
                        _ComplaintCard(complaint: list[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  const _ComplaintCard({required this.complaint});

  static const _icons = {
    'food': Icons.restaurant_outlined,
    'cleaning': Icons.cleaning_services_outlined,
    'security': Icons.security_outlined,
    'electrical': Icons.electrical_services_outlined,
    'internet': Icons.wifi_outlined,
    'furniture': Icons.chair_outlined,
    'plumbing': Icons.water_drop_outlined,
    'other': Icons.more_horiz_rounded,
  };

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.go('/complaint/${complaint.id}'),
        child: DcCard(
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _icons[complaint.category.name] ??
                    Icons.report_outlined,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(complaint.category.name.snakeToTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                    const SizedBox(width: 8),
                    DcStatusChip(status: complaint.status.name),
                  ]),
                  if (complaint.studentName != null)
                    Text(
                      '${complaint.studentName}  ·  Room ${complaint.roomNumber ?? '—'}',
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12),
                    ),
                  Text(
                    complaint.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.textTertiary, fontSize: 11),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _timeAgo(complaint.createdAt),
                  style: const TextStyle(
                      color: AppColors.textTertiary, fontSize: 10),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textTertiary, size: 16),
              ],
            ),
          ]),
        ),
      );

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
