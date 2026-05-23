import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _maintenanceDetailProvider =
    FutureProvider.family<MaintenanceRequest, String>((ref, id) async =>
        ref.watch(maintenanceApiProvider).getById(id));

class MaintenanceDetailScreen extends ConsumerWidget {
  final String requestId;
  const MaintenanceDetailScreen({super.key, required this.requestId});

  static const _categoryIcons = {
    'plumbing': Icons.water_drop_outlined,
    'electrical': Icons.electrical_services_outlined,
    'carpentry': Icons.handyman_outlined,
    'painting': Icons.format_paint_outlined,
    'civil': Icons.foundation_outlined,
    'appliance': Icons.kitchen_outlined,
    'other': Icons.build_outlined,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reqAsync = ref.watch(_maintenanceDetailProvider(requestId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(_maintenanceDetailProvider(requestId)),
          ),
        ],
      ),
      body: reqAsync.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(message: e.toString()),
        data: (req) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              DcCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _categoryIcons[req.category.name] ??
                              Icons.build_outlined,
                          color: AppColors.warning,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              req.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                            Text(
                              req.category.name.snakeToTitle,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      DcStatusChip(status: req.status.name),
                    ]),
                    const SizedBox(height: 12),
                    if (req.location != null)
                      Row(children: [
                        const Icon(Icons.place_outlined,
                            size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(req.location!,
                            style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12)),
                      ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.schedule_outlined,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        'Filed on ${req.createdAt?.formatted ?? '—'}',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ]),
                    if (req.scheduledAt != null) ...[
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.event_outlined,
                            size: 14, color: AppColors.info),
                        const SizedBox(width: 6),
                        Text(
                          'Scheduled: ${req.scheduledAt!.formatted}',
                          style: const TextStyle(
                              color: AppColors.info, fontSize: 12),
                        ),
                      ]),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Description
              const Text('Description',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(req.description,
                    style: const TextStyle(
                        color: AppColors.textSecondary, height: 1.5)),
              ),
              const SizedBox(height: 16),

              // Assigned staff
              if (req.assignedToName != null) ...[
                DcCard(
                  child: Row(children: [
                    const Icon(Icons.person_outlined,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Assigned Staff',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11)),
                        Text(req.assignedToName!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ]),
                ),
                const SizedBox(height: 12),
              ],

              // Resolution note
              if (req.fixedNote != null) ...[
                const Text('Resolution Note',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Text(req.fixedNote!,
                      style: const TextStyle(height: 1.5)),
                ),
                const SizedBox(height: 16),
              ],

              // Completed
              if (req.completedAt != null)
                DcCard(
                  child: Row(children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.success, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Completed on ${req.completedAt!.formatted}',
                      style: const TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w500),
                    ),
                  ]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
