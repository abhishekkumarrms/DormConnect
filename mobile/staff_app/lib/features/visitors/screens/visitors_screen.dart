import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _pendingVisitorsProvider =
    FutureProvider.autoDispose<List<Visitor>>((ref) async =>
        ref.watch(visitorApiProvider).list(status: 'requested'));

final _insideVisitorsProvider =
    FutureProvider.autoDispose<List<Visitor>>((ref) async =>
        ref.watch(visitorApiProvider).getActive());

final _visitorHistoryProvider =
    FutureProvider.autoDispose<List<Visitor>>((ref) async =>
        ref.watch(visitorApiProvider).list());

class VisitorsScreen extends ConsumerStatefulWidget {
  const VisitorsScreen({super.key});

  @override
  ConsumerState<VisitorsScreen> createState() =>
      _VisitorsScreenState();
}

class _VisitorsScreenState extends ConsumerState<VisitorsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

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
    ref.invalidate(_pendingVisitorsProvider);
    ref.invalidate(_insideVisitorsProvider);
    ref.invalidate(_visitorHistoryProvider);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final role = user?.role ?? UserRole.warden;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitors'),
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
            Tab(text: 'Pending'),
            Tab(text: 'Inside'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _PendingTab(
              onRefresh: _refreshAll,
              canApprove:
                  role == UserRole.caretaker || role == UserRole.warden),
          _InsideTab(onRefresh: _refreshAll),
          _HistoryTab(onRefresh: _refreshAll),
        ],
      ),
    );
  }
}

class _PendingTab extends ConsumerWidget {
  final VoidCallback onRefresh;
  final bool canApprove;
  const _PendingTab(
      {required this.onRefresh, required this.canApprove});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_pendingVisitorsProvider);
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) =>
          DcErrorState(message: e.toString(), onRetry: onRefresh),
      data: (list) => list.isEmpty
          ? const DcEmptyState(
              icon: Icons.person_add_alt_outlined,
              title: 'No pending visitor requests')
          : RefreshIndicator(
              onRefresh: () async => onRefresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: list.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                itemBuilder: (_, i) => _VisitorCard(
                  visitor: list[i],
                  canApprove: canApprove,
                  onAction: onRefresh,
                ),
              ),
            ),
    );
  }
}

class _InsideTab extends ConsumerWidget {
  final VoidCallback onRefresh;
  const _InsideTab({required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_insideVisitorsProvider);
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) =>
          DcErrorState(message: e.toString(), onRetry: onRefresh),
      data: (list) {
        if (list.isEmpty) {
          return const DcEmptyState(
              icon: Icons.sensor_door_outlined,
              title: 'No visitors inside');
        }
        return Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                vertical: 10, horizontal: 16),
            color: AppColors.warning.withOpacity(0.1),
            child: Text(
              'Currently inside: ${list.length}',
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.warning,
                  fontSize: 14),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => onRefresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: list.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                itemBuilder: (_, i) => _VisitorCard(
                  visitor: list[i],
                  canApprove: false,
                  onAction: onRefresh,
                ),
              ),
            ),
          ),
        ]);
      },
    );
  }
}

class _HistoryTab extends ConsumerWidget {
  final VoidCallback onRefresh;
  const _HistoryTab({required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_visitorHistoryProvider);
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) =>
          DcErrorState(message: e.toString(), onRetry: onRefresh),
      data: (list) => list.isEmpty
          ? const DcEmptyState(
              icon: Icons.history_rounded, title: 'No visitor history')
          : RefreshIndicator(
              onRefresh: () async => onRefresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: list.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                itemBuilder: (_, i) => _VisitorCard(
                  visitor: list[i],
                  canApprove: false,
                  onAction: onRefresh,
                ),
              ),
            ),
    );
  }
}

class _VisitorCard extends ConsumerWidget {
  final Visitor visitor;
  final bool canApprove;
  final VoidCallback onAction;
  const _VisitorCard({
    required this.visitor,
    required this.canApprove,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
        onTap: () => context.go('/visitors/${visitor.id}'),
        child: DcCard(
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person_outlined,
                  color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(visitor.visitorName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                    const SizedBox(width: 8),
                    DcStatusChip(status: visitor.status.name),
                  ]),
                  if (visitor.relation != null)
                    Text(visitor.relation!,
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12)),
                  Text(visitor.visitorPhone,
                      style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 11)),
                ],
              ),
            ),
            if (canApprove &&
                visitor.status == VisitorStatus.requested)
              Row(children: [
                IconButton(
                  icon: const Icon(Icons.check_circle_outline,
                      color: AppColors.success),
                  onPressed: () => _approve(context, ref),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined,
                      color: AppColors.error),
                  onPressed: () => _reject(context, ref),
                ),
              ])
            else
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textTertiary, size: 16),
          ]),
        ),
      );

  Future<void> _approve(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(visitorApiProvider).approve(visitor.id);
      onAction();
      if (context.mounted) {
        DcSnackbar.success(context, 'Visitor approved');
      }
    } catch (e) {
      if (context.mounted) DcSnackbar.error(context, e.toString());
    }
  }

  Future<void> _reject(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(visitorApiProvider).reject(visitor.id);
      onAction();
      if (context.mounted) {
        DcSnackbar.success(context, 'Visitor rejected');
      }
    } catch (e) {
      if (context.mounted) DcSnackbar.error(context, e.toString());
    }
  }
}
