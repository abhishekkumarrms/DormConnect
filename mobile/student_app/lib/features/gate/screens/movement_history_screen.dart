import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _movementHistoryProvider =
    FutureProvider<List<MovementLog>>((ref) async =>
        ref.watch(gateApiProvider).getHistory(limit: 100));

class MovementHistoryScreen extends ConsumerWidget {
  const MovementHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(_movementHistoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movement History'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_movementHistoryProvider)),
        ],
      ),
      body: history.when(
        loading: () => const DcLoading(),
        error: (e, _) =>
            DcErrorState(message: e.toString(), onRetry: () => ref.invalidate(_movementHistoryProvider)),
        data: (list) {
          if (list.isEmpty) {
            return const DcEmptyState(
              icon: Icons.history_rounded,
              title: 'No movement records',
              subtitle: 'Your gate activity will appear here',
            );
          }
          // Group by date
          final Map<String, List<MovementLog>> grouped = {};
          for (final m in list) {
            final key = m.createdAt?.formatted ?? 'Unknown';
            grouped.putIfAbsent(key, () => []).add(m);
          }
          final dates = grouped.keys.toList();
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dates.length,
            itemBuilder: (_, i) {
              final date = dates[i];
              final items = grouped[date]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(date,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                            fontSize: 12)),
                  ),
                  ...items.map((m) => _MovementItem(log: m)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _MovementItem extends StatelessWidget {
  final MovementLog log;
  const _MovementItem({required this.log});

  @override
  Widget build(BuildContext context) {
    final isOut = log.type == MovementType.out;
    final color = isOut ? AppColors.warning : AppColors.success;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DcCard(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isOut
                  ? Icons.arrow_circle_up_rounded
                  : Icons.arrow_circle_down_rounded,
              color: color,
              size: 22,
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
                        fontSize: 13,
                        color: color)),
                if (log.destination != null)
                  Text('📍 ${log.destination}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary)),
                if (log.isOverdue)
                  const Text('⚠️ Overdue return',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.error)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(log.createdAt?.timeOnly ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12)),
              if (log.isFlagged)
                const Text('Manual',
                    style: TextStyle(
                        fontSize: 10, color: AppColors.textTertiary)),
            ],
          ),
        ]),
      ),
    );
  }
}
