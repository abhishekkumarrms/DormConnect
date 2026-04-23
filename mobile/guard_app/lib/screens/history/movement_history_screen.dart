import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _historyProvider =
    FutureProvider.autoDispose<List<MovementLog>>((ref) async {
  return ref.watch(gateApiProvider).getHistory(limit: 100);
});

class MovementHistoryScreen extends ConsumerWidget {
  const MovementHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(_historyProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movement History'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_historyProvider)),
        ],
      ),
      body: history.when(
        loading: () => const DcShimmerList(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) => list.isEmpty
            ? const DcEmptyState(
                icon: Icons.history,
                title: 'No movement records')
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (_, i) {
                  final m = list[i];
                  final isOut = m.type == MovementType.out;
                  return DcCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (isOut
                                    ? AppColors.warning
                                    : AppColors.success)
                                .withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isOut
                                ? Icons.arrow_circle_up_outlined
                                : Icons.arrow_circle_down_outlined,
                            color: isOut
                                ? AppColors.warning
                                : AppColors.success,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.studentName ?? '—',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                              Text(
                                  'Room: ${m.roomNumber ?? '—'} • ${m.type.name}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Text(m.createdAt?.formattedWithTime ?? '',
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textTertiary)),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
