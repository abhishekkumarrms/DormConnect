import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _liveOutProvider =
    FutureProvider.autoDispose<List<MovementLog>>((ref) async {
  final hostelId = ref.watch(currentUserProvider)?.hostelId;
  return ref.watch(gateApiProvider).getLiveOut(hostelId: hostelId);
});

final _todayLogProvider =
    FutureProvider.autoDispose<List<MovementLog>>((ref) async {
  final hostelId = ref.watch(currentUserProvider)?.hostelId;
  // Use hostel-scoped shift-log endpoint via apiClientProvider
  if (hostelId == null) return [];
  final resp = await ref
      .read(apiClientProvider)
      .get('/api/v1/gate/shift-log', params: {'hostel_id': hostelId});
  final j = resp.data as Map<String, dynamic>;
  return (j['logs'] as List? ?? [])
      .map((e) => MovementLog.fromJson(e as Map<String, dynamic>))
      .toList();
});

final _liveRequestsProvider =
    FutureProvider.autoDispose<List<LiveRequest>>((ref) async {
  final hostelId = ref.watch(currentUserProvider)?.hostelId;
  return ref.watch(gateApiProvider).getLiveRequests(hostelId: hostelId);
});

class GateMonitorScreen extends ConsumerStatefulWidget {
  const GateMonitorScreen({super.key});

  @override
  ConsumerState<GateMonitorScreen> createState() =>
      _GateMonitorScreenState();
}

class _GateMonitorScreenState extends ConsumerState<GateMonitorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  void _refreshAll() {
    ref.invalidate(_liveOutProvider);
    ref.invalidate(_todayLogProvider);
    ref.invalidate(_liveRequestsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final role = user?.role ?? UserRole.warden;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gate Monitor'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh), onPressed: _refreshAll),
        ],
        bottom: TabBar(
          controller: _tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: AppColors.secondary,
          tabs: const [
            Tab(text: 'Live OUT'),
            Tab(text: 'Flagged'),
            Tab(text: "Today's Log"),
          ],
        ),
      ),
      floatingActionButton: role == UserRole.caretaker
          ? FloatingActionButton.extended(
              onPressed: () => _showManualEntry(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Manual Entry'),
              backgroundColor: AppColors.primary,
            )
          : null,
      body: TabBarView(
        controller: _tab,
        children: [
          _LiveOutTab(onRefresh: _refreshAll),
          _FlaggedTab(onRefresh: _refreshAll),
          _TodayLogTab(
              search: _search,
              onSearch: (v) => setState(() => _search = v)),
        ],
      ),
    );
  }

  void _showManualEntry(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Manual Entry'),
        content: DcTextField(
          label: 'Room Number',
          controller: ctrl,
          keyboardType: TextInputType.text,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(gateApiProvider).manualEntry(
                  ctrl.text.trim(), 'out',
                  note: 'Manual entry');
              DcSnackbar.success(context, 'Manual entry logged');
            },
            child: const Text('Log'),
          ),
        ],
      ),
    );
  }
}

class _LiveOutTab extends ConsumerWidget {
  final VoidCallback onRefresh;
  const _LiveOutTab({required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_liveOutProvider);
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) =>
          DcErrorState(message: e.toString(), onRetry: onRefresh),
      data: (list) => Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                vertical: 12, horizontal: 16),
            color: AppColors.warning.withOpacity(0.1),
            child: Text(
              'Currently OUT: ${list.length}',
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.warning,
                  fontSize: 15),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const DcEmptyState(
                    icon: Icons.sensor_door_outlined,
                    title: 'No students currently out')
                : RefreshIndicator(
                    onRefresh: () async => onRefresh(),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 6),
                      itemBuilder: (_, i) =>
                          _LiveOutCard(log: list[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _LiveOutCard extends StatelessWidget {
  final MovementLog log;
  const _LiveOutCard({required this.log});

  @override
  Widget build(BuildContext context) {
    final isOverdue = log.isOverdue;
    return DcCard(
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isOverdue
                ? AppColors.error.withOpacity(0.1)
                : AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_circle_up_rounded,
            color: isOverdue ? AppColors.error : AppColors.warning,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (log.destination != null)
                Text('📍 ${log.destination}',
                    style: const TextStyle(fontSize: 12)),
              Text(
                'Since ${log.createdAt?.timeOnly ?? ''}',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12),
              ),
              if (isOverdue)
                const Text('⚠️ Overdue return',
                    style: TextStyle(
                        color: AppColors.error, fontSize: 11)),
            ],
          ),
        ),
        if (log.isFlagged)
          const Icon(Icons.flag_rounded,
              color: AppColors.warning, size: 16),
      ]),
    );
  }
}

class _FlaggedTab extends ConsumerWidget {
  final VoidCallback onRefresh;
  const _FlaggedTab({required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_liveRequestsProvider);
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) =>
          DcErrorState(message: e.toString(), onRetry: onRefresh),
      data: (list) => list.isEmpty
          ? const DcEmptyState(
              icon: Icons.check_circle_outline,
              title: 'No flagged entries')
          : RefreshIndicator(
              onRefresh: () async => onRefresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (_, i) {
                  final r = list[i];
                  return DcCard(
                    child: Row(children: [
                      const Icon(Icons.flag_rounded,
                          color: AppColors.warning),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(r.studentName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                      ),
                      Text(
                        '${r.secondsRemaining}s',
                        style: const TextStyle(
                            color: AppColors.warning, fontSize: 12),
                      ),
                    ]),
                  );
                },
              ),
            ),
    );
  }
}

class _TodayLogTab extends ConsumerWidget {
  final String search;
  final ValueChanged<String> onSearch;
  const _TodayLogTab(
      {required this.search, required this.onSearch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_todayLogProvider);
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) => DcErrorState(message: e.toString()),
      data: (list) {
        final filtered = search.isEmpty
            ? list
            : list
                .where((m) =>
                    m.destination
                        ?.toLowerCase()
                        .contains(search.toLowerCase()) ??
                    false)
                .toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search destination…',
                  prefixIcon: Icon(Icons.search_rounded, size: 18),
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                onChanged: onSearch,
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const DcEmptyState(
                      icon: Icons.history_rounded,
                      title: 'No movements today')
                  : ListView.separated(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 6),
                      itemBuilder: (_, i) {
                        final m = filtered[i];
                        final isOut = m.type == MovementType.out;
                        return DcCard(
                          padding: const EdgeInsets.all(12),
                          child: Row(children: [
                            Icon(
                              isOut
                                  ? Icons.arrow_circle_up_rounded
                                  : Icons.arrow_circle_down_rounded,
                              color: isOut
                                  ? AppColors.warning
                                  : AppColors.success,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isOut ? 'Left' : 'Returned',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                  ),
                                  if (m.destination != null)
                                    Text(m.destination!,
                                        style: const TextStyle(
                                            color:
                                                AppColors.textSecondary,
                                            fontSize: 11)),
                                ],
                              ),
                            ),
                            Text(m.createdAt?.timeOnly ?? '',
                                style: const TextStyle(
                                    color: AppColors.textTertiary,
                                    fontSize: 11)),
                          ]),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
