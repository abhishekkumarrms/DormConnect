import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/gate_provider.dart';

class ShiftLogScreen extends ConsumerWidget {
  const ShiftLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gate = ref.watch(gateProvider);
    final log = gate.recentConfirms;
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: Text(
          'TODAY\'S LOG  —  ${DateFormat('EEE d MMM').format(today)}',
          style: const TextStyle(fontSize: 15),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/gate'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(gateProvider.notifier).refresh(),
          ),
        ],
      ),
      body: log.isEmpty
          ? const _EmptyLog()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: log.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) => _LogRow(entry: log[i]),
            ),
    );
  }
}

class _EmptyLog extends StatelessWidget {
  const _EmptyLog();

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history_rounded,
                size: 48, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 12),
            Text(
              'No entries yet this session',
              style: const TextStyle(
                  fontSize: 16, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      );
}

class _LogRow extends StatelessWidget {
  final ConfirmedEntry entry;
  const _LogRow({required this.entry});

  bool get _isOut => entry.movementType == 'out';

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          // Time
          SizedBox(
            width: 60,
            child: Text(
              DateFormat('h:mm a').format(entry.confirmedAt),
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Direction icon
          Icon(
            _isOut
                ? Icons.arrow_circle_up_rounded
                : Icons.arrow_circle_down_rounded,
            color: _isOut
                ? const Color(0xFFEF4444)
                : const Color(0xFF10B981),
            size: 20,
          ),
          const SizedBox(width: 10),

          // Name + room
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.studentName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Rm ${entry.roomNumber}',
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ),

          // Direction label + manual badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _isOut ? '↑ EXIT' : '↓ ENTRY',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _isOut
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF10B981),
                ),
              ),
              if (entry.wasManual)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF9C3),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color: const Color(0xFFFBBF24).withOpacity(0.5)),
                  ),
                  child: const Text(
                    '⚠️ Manual',
                    style: TextStyle(
                        fontSize: 10, color: Color(0xFF92400E)),
                  ),
                ),
            ],
          ),
        ]),
      );
}
