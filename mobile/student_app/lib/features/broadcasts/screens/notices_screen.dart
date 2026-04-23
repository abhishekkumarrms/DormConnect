import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _studentForNoticesProvider = FutureProvider<Student>((ref) async =>
    ref.watch(studentApiProvider).getProfile());

final _noticesProvider = FutureProvider<List<Notice>>((ref) async {
  final student = await ref.watch(_studentForNoticesProvider.future);
  return ref.watch(broadcastApiProvider).getNotices(student.hostelId);
});

class NoticesScreen extends ConsumerWidget {
  const NoticesScreen({super.key});

  void _refresh(WidgetRef ref) {
    ref.invalidate(_studentForNoticesProvider);
    ref.invalidate(_noticesProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_noticesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notices'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refresh(ref),
          ),
        ],
      ),
      body: async.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(
            message: e.toString(),
            onRetry: () => _refresh(ref)),
        data: (list) {
          if (list.isEmpty) {
            return const DcEmptyState(
              icon: Icons.article_outlined,
              title: 'No notices',
              subtitle: 'No notices posted yet',
            );
          }
          return RefreshIndicator(
            onRefresh: () async => _refresh(ref),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _NoticeCard(notice: list[i]),
            ),
          );
        },
      ),
    );
  }
}

class _NoticeCard extends StatefulWidget {
  final Notice notice;
  const _NoticeCard({required this.notice});

  @override
  State<_NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<_NoticeCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return DcCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.notice.isPinned
                      ? AppColors.warning.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.notice.isPinned
                      ? Icons.push_pin_rounded
                      : Icons.article_outlined,
                  size: 16,
                  color: widget.notice.isPinned
                      ? AppColors.warning
                      : AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.notice.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.notice.createdAt?.formatted ?? '',
                      style: const TextStyle(
                          color: AppColors.textTertiary, fontSize: 11),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          if (_expanded) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Text(
              widget.notice.body,
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.6),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              widget.notice.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  height: 1.4),
            ),
          ],
        ],
      ),
    );
  }
}
