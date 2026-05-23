import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

final _leavesListProvider =
    FutureProvider.autoDispose.family<List<LeaveApplication>, String?>(
        (ref, status) async =>
            ref.watch(leaveApiProvider).list(status: status, limit: 100));

final _leaveCalendarProvider =
    FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String>(
        (ref, yearMonth) async {
  final user = ref.watch(currentUserProvider);
  final hostelId = user?.hostelId ?? '';
  if (hostelId.isEmpty) return [];
  return ref.watch(leaveApiProvider).getCalendar(hostelId, yearMonth);
});

class LeavesScreen extends ConsumerStatefulWidget {
  const LeavesScreen({super.key});

  @override
  ConsumerState<LeavesScreen> createState() => _LeavesScreenState();
}

class _LeavesScreenState extends ConsumerState<LeavesScreen> {
  bool _calendarView = false;
  String? _statusFilter;
  DateTime _focusedDay = DateTime.now();

  static const _filters = [
    ('All', null),
    ('Submitted', 'submitted'),
    ('Under Review', 'underReview'),
    ('Guardian Contacted', 'guardianContacted'),
    ('Approved', 'approved'),
    ('Rejected', 'rejected'),
  ];

  String get _yearMonth =>
      DateFormat('yyyy-MM').format(_focusedDay);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Applications'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_calendarView
                ? Icons.list_rounded
                : Icons.calendar_month_rounded),
            onPressed: () =>
                setState(() => _calendarView = !_calendarView),
            tooltip:
                _calendarView ? 'List view' : 'Calendar view',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(_leavesListProvider(_statusFilter));
              ref.invalidate(_leaveCalendarProvider(_yearMonth));
            },
          ),
        ],
      ),
      body: _calendarView
          ? _CalendarView(
              focusedDay: _focusedDay,
              onDayChanged: (d) =>
                  setState(() => _focusedDay = d),
              yearMonth: _yearMonth,
            )
          : _ListView(
              statusFilter: _statusFilter,
              filters: _filters,
              onFilterChanged: (f) =>
                  setState(() => _statusFilter = f),
            ),
    );
  }
}

class _ListView extends ConsumerWidget {
  final String? statusFilter;
  final List<(String, String?)> filters;
  final ValueChanged<String?> onFilterChanged;

  const _ListView({
    required this.statusFilter,
    required this.filters,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_leavesListProvider(statusFilter));
    return Column(children: [
      SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 6),
          children: filters
              .map((f) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(f.$1),
                      selected: statusFilter == f.$2,
                      selectedColor:
                          AppColors.primary.withOpacity(0.15),
                      onSelected: (_) => onFilterChanged(f.$2),
                    ),
                  ))
              .toList(),
        ),
      ),
      Expanded(
        child: async.when(
          loading: () => const DcLoading(),
          error: (e, _) => DcErrorState(
              message: e.toString(),
              onRetry: () =>
                  ref.invalidate(_leavesListProvider(statusFilter))),
          data: (list) {
            if (list.isEmpty) {
              return const DcEmptyState(
                  icon: Icons.flight_takeoff_rounded,
                  title: 'No leave applications');
            }
            return RefreshIndicator(
              onRefresh: () async =>
                  ref.invalidate(_leavesListProvider(statusFilter)),
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: list.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                itemBuilder: (_, i) =>
                    _LeaveCard(leave: list[i]),
              ),
            );
          },
        ),
      ),
    ]);
  }
}

class _LeaveCard extends StatelessWidget {
  final LeaveApplication leave;
  const _LeaveCard({required this.leave});

  Color get _typeColor => switch (leave.leaveType) {
        LeaveType.medical => AppColors.error,
        LeaveType.home => AppColors.primary,
        LeaveType.academic => AppColors.info,
        LeaveType.personal => AppColors.warning,
      };

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.go('/leaves/${leave.id}'),
        child: DcCard(
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _typeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                leave.leaveType == LeaveType.medical
                    ? Icons.local_hospital_outlined
                    : Icons.flight_takeoff_rounded,
                color: _typeColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      leave.studentName ?? 'Student',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    DcStatusChip(status: leave.status.name),
                  ]),
                  Text(
                    '${leave.leaveType.name.snakeToTitle}  ·  '
                    '${DateFormat('dd MMM').format(leave.fromDate)} – '
                    '${DateFormat('dd MMM').format(leave.toDate)}',
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12),
                  ),
                  if (leave.destination != null)
                    Text(
                      leave.destination!,
                      style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 11),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (leave.guardianConfirmed)
                  const Icon(Icons.verified_outlined,
                      size: 14, color: AppColors.success),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textTertiary, size: 16),
              ],
            ),
          ]),
        ),
      );
}

class _CalendarView extends ConsumerStatefulWidget {
  final DateTime focusedDay;
  final ValueChanged<DateTime> onDayChanged;
  final String yearMonth;

  const _CalendarView({
    required this.focusedDay,
    required this.onDayChanged,
    required this.yearMonth,
  });

  @override
  ConsumerState<_CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<_CalendarView> {
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final async =
        ref.watch(_leaveCalendarProvider(widget.yearMonth));

    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) => DcErrorState(message: e.toString()),
      data: (entries) {
        // Group by date
        final byDate = <String, List<Map<String, dynamic>>>{};
        for (final e in entries) {
          final d = e['date'] as String? ?? '';
          (byDate[d] ??= []).add(e);
        }

        List<Map<String, dynamic>> selectedEntries = [];
        if (_selectedDay != null) {
          final key =
              DateFormat('yyyy-MM-dd').format(_selectedDay!);
          selectedEntries = byDate[key] ?? [];
        }

        return Column(children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2027, 12, 31),
            focusedDay: widget.focusedDay,
            selectedDayPredicate: (d) =>
                isSameDay(d, _selectedDay),
            onDaySelected: (sel, focus) {
              setState(() => _selectedDay = sel);
              widget.onDayChanged(focus);
            },
            onPageChanged: widget.onDayChanged,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.warning,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (ctx, day, _) {
                final key = DateFormat('yyyy-MM-dd').format(day);
                final count = byDate[key]?.length ?? 0;
                if (count == 0) return const SizedBox();
                return Positioned(
                  bottom: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.warning,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
          if (_selectedDay != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                '${selectedEntries.length} absent on ${DateFormat('dd MMM').format(_selectedDay!)}',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
            Expanded(
              child: selectedEntries.isEmpty
                  ? const DcEmptyState(
                      icon: Icons.check_circle_outline,
                      title: 'No absences this day')
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: selectedEntries.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 6),
                      itemBuilder: (_, i) {
                        final e = selectedEntries[i];
                        return DcCard(
                          padding: const EdgeInsets.all(12),
                          child: Row(children: [
                            const Icon(
                                Icons.person_outline_rounded,
                                size: 16,
                                color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                e['studentName'] as String? ??
                                    'Student',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                            ),
                            if (e['leaveType'] != null)
                              DcStatusChip(
                                  status: e['leaveType'] as String),
                          ]),
                        );
                      },
                    ),
            ),
          ] else
            const Expanded(
              child: Center(
                child: Text('Tap a date to see absences',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13)),
              ),
            ),
        ]);
      },
    );
  }
}
