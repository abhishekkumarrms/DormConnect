import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _myComplaintsListProvider =
    FutureProvider<List<Complaint>>((ref) async =>
        ref.watch(complaintApiProvider).list(limit: 50));

final _myMaintenanceListProvider =
    FutureProvider<List<MaintenanceRequest>>((ref) async =>
        ref.watch(maintenanceApiProvider).listMine());

class ActivityTab extends ConsumerWidget {
  const ActivityTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Activity'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: AppColors.secondary,
            tabs: [
              Tab(text: 'Complaints'),
              Tab(text: 'Maintenance'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showNewRequestSheet(context),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add_rounded),
        ),
        body: TabBarView(
          children: [
            _ComplaintsList(
              onRefresh: () => ref.invalidate(_myComplaintsListProvider),
            ),
            _MaintenanceList(
              onRefresh: () => ref.invalidate(_myMaintenanceListProvider),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewRequestSheet(BuildContext context) {
    DcBottomSheet.show<void>(
      context,
      title: 'New Request',
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.report_outlined,
                    color: AppColors.error, size: 22),
              ),
              title: const Text('File a Complaint',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Report an issue with hostel services'),
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textTertiary),
              onTap: () {
                Navigator.pop(context);
                context.go('/complaint/new');
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.build_outlined,
                    color: AppColors.warning, size: 22),
              ),
              title: const Text('Maintenance Request',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Request repairs or upkeep'),
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textTertiary),
              onTap: () {
                Navigator.pop(context);
                context.go('/maintenance/new');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ComplaintsList extends ConsumerWidget {
  final VoidCallback onRefresh;
  const _ComplaintsList({required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_myComplaintsListProvider);
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) =>
          DcErrorState(message: e.toString(), onRetry: onRefresh),
      data: (list) {
        if (list.isEmpty) {
          return const DcEmptyState(
            icon: Icons.check_circle_outline_rounded,
            title: 'No complaints filed',
            subtitle: 'Use the + button to report an issue',
          );
        }
        return RefreshIndicator(
          onRefresh: () async => onRefresh(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _ComplaintCard(complaint: list[i]),
          ),
        );
      },
    );
  }
}

class _MaintenanceList extends ConsumerWidget {
  final VoidCallback onRefresh;
  const _MaintenanceList({required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_myMaintenanceListProvider);
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) =>
          DcErrorState(message: e.toString(), onRetry: onRefresh),
      data: (list) {
        if (list.isEmpty) {
          return const DcEmptyState(
            icon: Icons.build_circle_outlined,
            title: 'No maintenance requests',
            subtitle: 'Use the + button to request maintenance',
          );
        }
        return RefreshIndicator(
          onRefresh: () async => onRefresh(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _MaintenanceCard(request: list[i]),
          ),
        );
      },
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  const _ComplaintCard({required this.complaint});

  static const _categoryIcons = {
    'food': Icons.restaurant_outlined,
    'staffBehavior': Icons.person_off_outlined,
    'security': Icons.security_outlined,
    'environment': Icons.nature_outlined,
    'ragging': Icons.report_problem_outlined,
    'other': Icons.more_horiz_rounded,
  };

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.go('/complaint/${complaint.id}'),
        child: DcCard(
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _categoryIcons[complaint.category.name] ??
                    Icons.report_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      complaint.category.name.snakeToTitle,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    DcStatusChip(status: complaint.status.name),
                  ]),
                  const SizedBox(height: 4),
                  Text(
                    complaint.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    complaint.createdAt?.formatted ?? '',
                    style: const TextStyle(
                        color: AppColors.textTertiary, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textTertiary, size: 18),
          ]),
        ),
      );
}

class _MaintenanceCard extends StatelessWidget {
  final MaintenanceRequest request;
  const _MaintenanceCard({required this.request});

  static const _typeIcons = {
    'plumbing': Icons.water_drop_outlined,
    'electrical': Icons.electrical_services_outlined,
    'furniture': Icons.chair_outlined,
    'internet': Icons.wifi_outlined,
    'cleanliness': Icons.cleaning_services_outlined,
    'other': Icons.build_outlined,
  };

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.go('/maintenance/${request.id}'),
        child: DcCard(
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _typeIcons[request.category.name] ??
                    Icons.build_outlined,
                color: AppColors.warning,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      request.category.name.snakeToTitle,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    DcStatusChip(status: request.status.name),
                  ]),
                  const SizedBox(height: 4),
                  Text(
                    request.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    request.createdAt?.formatted ?? '',
                    style: const TextStyle(
                        color: AppColors.textTertiary, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textTertiary, size: 18),
          ]),
        ),
      );
}
