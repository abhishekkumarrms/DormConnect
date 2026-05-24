import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/gate_provider.dart';

class ShiftLogScreen extends ConsumerWidget {
  const ShiftLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final logAsync = ref.watch(shiftLogProvider);

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
            onPressed: () => ref.invalidate(shiftLogProvider),
          ),
        ],
      ),
      body: logAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 40, color: Color(0xFFEF4444)),
              const SizedBox(height: 12),
              Text(
                'Failed to load log',
                style: const TextStyle(
                    fontSize: 16, color: Color(0xFF1E293B),
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(e.toString(),
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF94A3B8))),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => ref.invalidate(shiftLogProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (log) => log.isEmpty
            ? const _EmptyLog()
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: log.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1),
                itemBuilder: (_, i) => _LogRow(entry: log[i]),
              ),
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
            const Text(
              'No entries yet today',
              style: TextStyle(fontSize: 16, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      );
}

class _LogRow extends StatelessWidget {
  final ShiftLogEntry entry;
  const _LogRow({required this.entry});

  bool get _isOut => entry.movementType == 'OUT';

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          // Time
          SizedBox(
            width: 60,
            child: Text(
              entry.createdAt != null
                  ? DateFormat('h:mm a').format(entry.createdAt!.toLocal())
                  : '—',
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

          // Name + room + destination
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.studentName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Row(children: [
                  Text(
                    'Rm ${entry.roomNumber}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                  if (entry.destination != null) ...[
                    const Text(' · ',
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF9CA3AF))),
                    Flexible(
                      child: Text(
                        entry.destination!,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF9CA3AF)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ]),
              ],
            ),
          ),

          // Direction label + flags
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (entry.isOverdue)
                    const Icon(Icons.timer_off_outlined,
                        size: 14, color: Color(0xFFEF4444)),
                  if (entry.isFlagged)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.flag_rounded,
                          size: 14, color: Color(0xFFF59E0B)),
                    ),
                ],
              ),
            ],
          ),
        ]),
      );
}
