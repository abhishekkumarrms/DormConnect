import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/child_provider.dart';

final _movementsProvider =
    FutureProvider.autoDispose<List<MovementLog>>((ref) async {
  final child = ref.read(childProvider);
  final studentId = child.student?.id;
  if (studentId == null) return [];
  final resp = await ref.read(apiClientProvider).get(
    '/api/v1/gate/history/$studentId',
    params: {'limit': 100},
  );
  return (resp.data as List<dynamic>)
      .map((e) => MovementLog.fromJson(e as Map<String, dynamic>))
      .toList();
});

class MovementsScreen extends ConsumerWidget {
  const MovementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movement = ref.watch(_movementsProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Movement History',
            style: TextStyle(
                color: Color(0xFF0F172A), fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0F172A)),
            onPressed: () => ref.invalidate(_movementsProvider),
          ),
        ],
      ),
      body: movement.when(
        loading: () =>
            const Padding(padding: EdgeInsets.all(16), child: DcShimmerList()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) => list.isEmpty
            ? const DcEmptyState(
                icon: Icons.directions_walk_outlined,
                title: 'No movement records',
                subtitle: 'Movement history will appear here',
              )
            : _GroupedList(logs: list),
      ),
    );
  }
}

class _GroupedList extends StatelessWidget {
  final List<MovementLog> logs;
  const _GroupedList({required this.logs});

  Map<String, List<MovementLog>> _group() {
    final map = <String, List<MovementLog>>{};
    for (final log in logs) {
      final key = log.createdAt != null
          ? DateFormat('EEEE, d MMM yyyy').format(log.createdAt!)
          : 'Unknown';
      map.putIfAbsent(key, () => []).add(log);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _group();
    final days = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: days.length,
      itemBuilder: (_, i) {
        final day = days[i];
        final entries = grouped[day]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                day,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B)),
              ),
            ),
            ...entries.map((log) => _MovementRow(log: log)),
            const SizedBox(height: 4),
          ],
        );
      },
    );
  }
}

class _MovementRow extends StatelessWidget {
  final MovementLog log;
  const _MovementRow({required this.log});

  @override
  Widget build(BuildContext context) {
    final isOut = log.type == MovementType.out;
    final isManual = log.type == MovementType.manual;
    final rowColor =
        isOut ? const Color(0xFFEF4444) : const Color(0xFF10B981);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(children: [
        // Direction icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: rowColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isOut
                ? Icons.arrow_circle_up_rounded
                : Icons.arrow_circle_down_rounded,
            color: rowColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),

        // Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isManual
                    ? 'Manual Entry'
                    : isOut
                        ? 'Left Hostel'
                        : 'Returned to Hostel',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: rowColor),
              ),
              if (log.destination != null)
                Text('To: ${log.destination}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF6B7280))),
              if (log.note != null)
                Text(log.note!,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF6B7280))),
            ],
          ),
        ),

        // Time + badges
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              log.createdAt != null
                  ? DateFormat('h:mm a').format(log.createdAt!)
                  : '',
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF9CA3AF)),
            ),
            if (log.isOverdue)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '⚠ Overdue',
                  style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w600),
                ),
              ),
            if (isManual)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF9C3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Manual',
                  style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF92400E),
                      fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
      ]),
    );
  }
}
