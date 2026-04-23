import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _activeVisitorsProvider =
    FutureProvider.autoDispose<List<Visitor>>((ref) async {
  return ref.watch(visitorApiProvider).getActive();
});

final _approvedVisitorsProvider =
    FutureProvider.autoDispose<List<Visitor>>((ref) async {
  return ref.watch(visitorApiProvider).list(status: 'APPROVED');
});

class VisitorScreen extends ConsumerWidget {
  const VisitorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Visitors'),
          bottom: const TabBar(tabs: [
            Tab(text: 'Approved'),
            Tab(text: 'Inside'),
          ]),
        ),
        body: TabBarView(
          children: [
            _VisitorList(
              provider: _approvedVisitorsProvider,
              emptyTitle: 'No approved visitors',
              actionLabel: 'Entry',
              onAction: (ctx, ref, id) async {
                await ref.read(visitorApiProvider).guardEntry(id);
                ref.invalidate(_approvedVisitorsProvider);
                ref.invalidate(_activeVisitorsProvider);
              },
            ),
            _VisitorList(
              provider: _activeVisitorsProvider,
              emptyTitle: 'No visitors inside',
              actionLabel: 'Exit',
              onAction: (ctx, ref, id) async {
                await ref.read(visitorApiProvider).guardExit(id);
                ref.invalidate(_activeVisitorsProvider);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _VisitorList extends ConsumerWidget {
  final ProviderBase<AsyncValue<List<Visitor>>> provider;
  final String emptyTitle;
  final String actionLabel;
  final Future<void> Function(BuildContext, WidgetRef, String) onAction;

  const _VisitorList({
    required this.provider,
    required this.emptyTitle,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitors = ref.watch(provider);
    return visitors.when(
      loading: () => const DcShimmerList(count: 3),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (list) => list.isEmpty
          ? DcEmptyState(
              icon: Icons.person_search_outlined, title: emptyTitle)
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final v = list[i];
                return DcCard(
                  child: Row(
                    children: [
                      DcAvatar(name: v.visitorName, radius: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(v.visitorName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            Text(
                                '${v.relation ?? ''} • ${v.visitorPhone}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary)),
                            if (v.purpose != null)
                              Text(v.purpose!,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textTertiary)),
                          ],
                        ),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: actionLabel == 'Entry'
                                ? AppColors.success
                                : AppColors.warning,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8)),
                        onPressed: () async {
                          try {
                            await onAction(context, ref, v.id);
                            if (context.mounted) {
                              DcSnackbar.success(
                                  context, '$actionLabel recorded');
                            }
                          } catch (e) {
                            if (context.mounted) {
                              DcSnackbar.error(context, e.toString());
                            }
                          }
                        },
                        child: Text(actionLabel,
                            style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
