import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _maintenanceListProvider =
    FutureProvider.autoDispose.family<List<MaintenanceRequest>, String?>(
        (ref, status) async =>
            ref.watch(maintenanceApiProvider).list(status: status, limit: 100));

class MaintenanceScreen extends ConsumerStatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  ConsumerState<MaintenanceScreen> createState() =>
      _MaintenanceScreenState();
}

class _MaintenanceScreenState extends ConsumerState<MaintenanceScreen> {
  String? _statusFilter;

  static const _filters = [
    ('All', null),
    ('Submitted', 'submitted'),
    ('Assigned', 'assigned'),
    ('Scheduled', 'scheduled'),
    ('In Progress', 'inProgress'),
    ('Fixed', 'fixed'),
  ];

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(_maintenanceListProvider(_statusFilter));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(_maintenanceListProvider(_statusFilter)),
          ),
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            children: _filters
                .map((f) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(f.$1),
                        selected: _statusFilter == f.$2,
                        selectedColor:
                            AppColors.warning.withOpacity(0.15),
                        onSelected: (_) =>
                            setState(() => _statusFilter = f.$2),
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
                onRetry: () => ref.invalidate(
                    _maintenanceListProvider(_statusFilter))),
            data: (list) {
              if (list.isEmpty) {
                return const DcEmptyState(
                    icon: Icons.build_circle_outlined,
                    title: 'No maintenance requests');
              }
              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(
                    _maintenanceListProvider(_statusFilter)),
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 8),
                  itemBuilder: (_, i) =>
                      _MaintenanceCard(request: list[i]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _MaintenanceCard extends StatelessWidget {
  final MaintenanceRequest request;
  const _MaintenanceCard({required this.request});

  static const _icons = {
    'plumbing': Icons.water_drop_outlined,
    'electrical': Icons.electrical_services_outlined,
    'carpentry': Icons.handyman_outlined,
    'painting': Icons.format_paint_outlined,
    'civil': Icons.foundation_outlined,
    'appliance': Icons.kitchen_outlined,
    'other': Icons.build_outlined,
  };

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.go('/maintenance/${request.id}'),
        child: DcCard(
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _icons[request.category.name] ?? Icons.build_outlined,
                color: AppColors.warning,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(request.category.name.snakeToTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                    const SizedBox(width: 8),
                    DcStatusChip(status: request.status.name),
                  ]),
                  if (request.reportedByName != null)
                    Text(
                      'By ${request.reportedByName}  ·  Room ${request.roomNumber ?? '—'}',
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12),
                    ),
                  if (request.title != null)
                    Text(request.title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textTertiary, size: 16),
          ]),
        ),
      );
}
