import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _broadcastsProvider =
    FutureProvider.autoDispose<List<Broadcast>>((ref) async =>
        ref.watch(broadcastApiProvider).list(limit: 50));

class BroadcastsScreen extends ConsumerWidget {
  const BroadcastsScreen({super.key});

  static const _categoryColors = {
    BroadcastCategory.important: AppColors.error,
    BroadcastCategory.mess: AppColors.warning,
    BroadcastCategory.holiday: AppColors.success,
    BroadcastCategory.event: AppColors.info,
    BroadcastCategory.general: AppColors.primary,
  };

  static const _categoryIcons = {
    BroadcastCategory.important: Icons.priority_high_rounded,
    BroadcastCategory.mess: Icons.restaurant_outlined,
    BroadcastCategory.holiday: Icons.beach_access_outlined,
    BroadcastCategory.event: Icons.event_outlined,
    BroadcastCategory.general: Icons.campaign_outlined,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_broadcastsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Broadcasts'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_broadcastsProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/broadcasts/new'),
        icon: const Icon(Icons.campaign_outlined),
        label: const Text('New Broadcast'),
        backgroundColor: AppColors.primary,
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
                title: 'No broadcasts sent yet');
          }
          return RefreshIndicator(
            onRefresh: () async =>
                ref.invalidate(_broadcastsProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final b = list[i];
                final color =
                    _categoryColors[b.category] ?? AppColors.primary;
                final icon =
                    _categoryIcons[b.category] ?? Icons.campaign_outlined;
                return DcCard(
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(b.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                          Text(b.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12)),
                          Text(
                            '${b.sentByName}  ·  ${b.createdAt?.formatted ?? ''}',
                            style: const TextStyle(
                                color: AppColors.textTertiary,
                                fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
