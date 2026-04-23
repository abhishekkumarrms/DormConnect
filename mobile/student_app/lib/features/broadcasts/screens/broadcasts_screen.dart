import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _broadcastsProvider =
    FutureProvider<List<Broadcast>>((ref) async =>
        ref.watch(broadcastApiProvider).list(limit: 50));

class BroadcastsScreen extends ConsumerWidget {
  const BroadcastsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_broadcastsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_broadcastsProvider),
          ),
        ],
      ),
      body: async.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(
            message: e.toString(),
            onRetry: () => ref.invalidate(_broadcastsProvider)),
        data: (list) {
          if (list.isEmpty) {
            return const DcEmptyState(
              icon: Icons.campaign_outlined,
              title: 'No announcements',
              subtitle: 'Check back later',
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(_broadcastsProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _BroadcastCard(broadcast: list[i]),
            ),
          );
        },
      ),
    );
  }
}

class _BroadcastCard extends StatelessWidget {
  final Broadcast broadcast;
  const _BroadcastCard({required this.broadcast});

  static Color _categoryColor(BroadcastCategory c) {
    switch (c) {
      case BroadcastCategory.important:
        return AppColors.error;
      case BroadcastCategory.mess:
        return AppColors.warning;
      case BroadcastCategory.holiday:
        return AppColors.success;
      case BroadcastCategory.event:
        return AppColors.info;
      case BroadcastCategory.general:
        return AppColors.primary;
    }
  }

  static IconData _categoryIcon(BroadcastCategory c) {
    switch (c) {
      case BroadcastCategory.important:
        return Icons.priority_high_rounded;
      case BroadcastCategory.mess:
        return Icons.restaurant_outlined;
      case BroadcastCategory.holiday:
        return Icons.celebration_outlined;
      case BroadcastCategory.event:
        return Icons.event_outlined;
      case BroadcastCategory.general:
        return Icons.campaign_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(broadcast.category);
    return DcCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_categoryIcon(broadcast.category),
                  size: 16, color: color),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                broadcast.title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Text(
            broadcast.body,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5),
          ),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.schedule_outlined,
                size: 12, color: AppColors.textTertiary),
            const SizedBox(width: 4),
            Text(
              broadcast.createdAt?.formatted ?? '',
              style: const TextStyle(
                  color: AppColors.textTertiary, fontSize: 11),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                broadcast.category.name.snakeToTitle,
                style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
