import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/child_provider.dart';

final _noticesProvider =
    FutureProvider.autoDispose<List<Notice>>((ref) async {
  final child = ref.read(childProvider);
  final hostelId = child.student?.hostelId ?? '';
  if (hostelId.isEmpty) return [];
  return ref.read(broadcastApiProvider).getNotices(hostelId);
});

final _broadcastsProvider =
    FutureProvider.autoDispose<List<Broadcast>>((ref) async {
  return ref.read(broadcastApiProvider).list(limit: 30);
});

class NoticesScreen extends ConsumerWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notices = ref.watch(_noticesProvider);
    final broadcasts = ref.watch(_broadcastsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Notices & Updates',
            style: TextStyle(
                color: Color(0xFF0F172A), fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0F172A)),
            onPressed: () {
              ref.invalidate(_noticesProvider);
              ref.invalidate(_broadcastsProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(_noticesProvider);
          ref.invalidate(_broadcastsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Pinned Notices
            notices.when(
              loading: () => const DcShimmerList(count: 2),
              error: (_, __) => const SizedBox.shrink(),
              data: (list) {
                final pinned = list.where((n) => n.isPinned).toList();
                if (pinned.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionLabel(
                        label: '📌 Pinned Notices',
                        color: Color(0xFFF59E0B)),
                    const SizedBox(height: 8),
                    ...pinned.map((n) => _NoticeCard(n)),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),

            // All Notices
            notices.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (list) {
                final unpinned =
                    list.where((n) => !n.isPinned).toList();
                if (unpinned.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionLabel(label: 'Hostel Notices'),
                    const SizedBox(height: 8),
                    ...unpinned.map((n) => _NoticeCard(n)),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),

            // Broadcasts
            broadcasts.when(
              loading: () => const DcShimmerList(count: 3),
              error: (e, _) =>
                  Center(child: Text(e.toString())),
              data: (list) {
                final important = list
                    .where((b) =>
                        b.category == BroadcastCategory.important)
                    .toList();
                final rest = list
                    .where((b) =>
                        b.category != BroadcastCategory.important)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (important.isNotEmpty) ...[
                      const _SectionLabel(
                          label: 'Important Announcements',
                          color: Color(0xFFEF4444)),
                      const SizedBox(height: 8),
                      ...important.map((b) => _BroadcastCard(b)),
                      const SizedBox(height: 20),
                    ],
                    if (rest.isNotEmpty) ...[
                      const _SectionLabel(label: 'General Updates'),
                      const SizedBox(height: 8),
                      ...rest.map((b) => _BroadcastCard(b)),
                    ],
                    if (list.isEmpty)
                      const DcEmptyState(
                        icon: Icons.campaign_outlined,
                        title: 'No notices yet',
                        subtitle: 'Hostel announcements will appear here',
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color? color;
  const _SectionLabel({required this.label, this.color});

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color ?? const Color(0xFF334155)),
      );
}

class _NoticeCard extends StatelessWidget {
  final Notice notice;
  const _NoticeCard(this.notice);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notice.isPinned
              ? const Color(0xFFFEFCE8)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: notice.isPinned
                  ? const Color(0xFFFCD34D)
                  : const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              if (notice.isPinned) ...[
                const Icon(Icons.push_pin_rounded,
                    size: 14, color: Color(0xFFF59E0B)),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  notice.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
            ]),
            const SizedBox(height: 6),
            Text(
              notice.body,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Text(
                notice.postedByName,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              if (notice.createdAt != null)
                Text(
                  DateFormat('d MMM').format(notice.createdAt!),
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF9CA3AF)),
                ),
            ]),
          ],
        ),
      );
}

class _BroadcastCard extends StatelessWidget {
  final Broadcast broadcast;
  const _BroadcastCard(this.broadcast);

  Color get _catColor {
    switch (broadcast.category) {
      case BroadcastCategory.important:
        return const Color(0xFFEF4444);
      case BroadcastCategory.mess:
        return const Color(0xFF10B981);
      case BroadcastCategory.holiday:
        return const Color(0xFF3B82F6);
      case BroadcastCategory.event:
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: _catColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  broadcast.category.name,
                  style: TextStyle(
                      fontSize: 10,
                      color: _catColor,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const Spacer(),
              if (broadcast.createdAt != null)
                Text(
                  DateFormat('d MMM').format(broadcast.createdAt!),
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF9CA3AF)),
                ),
            ]),
            const SizedBox(height: 6),
            Text(
              broadcast.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              broadcast.body,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 6),
            Text(
              broadcast.sentByName,
              style: const TextStyle(
                  fontSize: 11, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
      );
}
