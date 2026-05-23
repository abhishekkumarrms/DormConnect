import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _liveOutProvider =
    FutureProvider.autoDispose<List<MovementLog>>((ref) async {
  return ref.watch(gateApiProvider).getLiveOut();
});

class LiveOutScreen extends ConsumerWidget {
  const LiveOutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveOut = ref.watch(_liveOutProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students Outside'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_liveOutProvider)),
        ],
      ),
      body: liveOut.when(
        loading: () => const DcShimmerList(count: 5),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) {
          if (list.isEmpty) {
            return const DcEmptyState(
              icon: Icons.people_outline,
              title: 'All students are inside',
            );
          }
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: AppColors.surfaceVariant,
                child: Row(children: [
                  const Icon(Icons.people_outline,
                      size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text('${list.length} student${list.length == 1 ? '' : 's'} outside',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary)),
                ]),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final m = list[i];
                    return DcCard(
                      child: Row(
                        children: [
                          DcAvatar(name: m.studentName ?? '?', radius: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m.studentName ?? '—',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    'Room: ${m.roomNumber ?? '—'}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(m.createdAt?.timeOnly ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
                              Text('Out since',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textTertiary)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
