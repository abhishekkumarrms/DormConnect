import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _movementProvider =
    FutureProvider<List<MovementLog>>((ref) async {
  return ref.watch(gateApiProvider).getHistory(limit: 50);
});

class MovementScreen extends ConsumerWidget {
  const MovementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movement = ref.watch(_movementProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movement History'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_movementProvider)),
        ],
      ),
      body: movement.when(
        loading: () => const DcShimmerList(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) => list.isEmpty
            ? const DcEmptyState(
                icon: Icons.directions_walk_outlined,
                title: 'No movement records',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (_, i) {
                  final m = list[i];
                  final isOut = m.type == MovementType.out;
                  return DcCard(
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
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
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: isOut
                              ? AppColors.warning
                              : AppColors.success,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(isOut ? 'Left Hostel' : 'Returned to Hostel',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: isOut
                                        ? AppColors.warning
                                        : AppColors.success)),
                            Text(m.createdAt?.formattedWithTime ?? '',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ]),
                  );
                },
              ),
      ),
    );
  }
}
