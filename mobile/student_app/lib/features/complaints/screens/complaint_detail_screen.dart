import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _complaintDetailProvider =
    FutureProvider.family<Complaint, String>((ref, id) async =>
        ref.watch(complaintApiProvider).getById(id));

class ComplaintDetailScreen extends ConsumerWidget {
  final String complaintId;
  const ComplaintDetailScreen({super.key, required this.complaintId});

  static const _categoryIcons = {
    'food': Icons.restaurant_outlined,
    'cleaning': Icons.cleaning_services_outlined,
    'security': Icons.security_outlined,
    'electrical': Icons.electrical_services_outlined,
    'internet': Icons.wifi_outlined,
    'furniture': Icons.chair_outlined,
    'plumbing': Icons.water_drop_outlined,
    'other': Icons.more_horiz_rounded,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complaintAsync = ref.watch(_complaintDetailProvider(complaintId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(_complaintDetailProvider(complaintId)),
          ),
        ],
      ),
      body: complaintAsync.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(message: e.toString()),
        data: (complaint) => SingleChildScrollView(
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
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _categoryIcons[complaint.category.name] ??
                              Icons.report_outlined,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          complaint.category.name.snakeToTitle,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ),
                      DcStatusChip(status: complaint.status.name),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      const Icon(Icons.schedule_outlined,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        'Filed on ${complaint.createdAt?.formatted ?? '—'}',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ]),
                    if (complaint.assignedToName != null) ...[
                      const SizedBox(height: 6),
                      Row(children: [
                        const Icon(Icons.person_outlined,
                            size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          'Assigned to ${complaint.assignedToName}',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
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
                child: Text(complaint.description,
                    style: const TextStyle(
                        color: AppColors.textSecondary, height: 1.5)),
              ),
              const SizedBox(height: 16),

              // Photo
              if (complaint.photoUrl != null) ...[
                const Text('Attached Photo',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    complaint.photoUrl!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 120,
                      color: AppColors.surfaceVariant,
                      child: const Center(
                          child: Icon(Icons.broken_image_outlined,
                              color: AppColors.textTertiary)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Updates / staff responses
              if (complaint.updates.isNotEmpty) ...[
                const Text('Updates',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 8),
                ...complaint.updates.map((u) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.info.withOpacity(0.25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(u.updatedByName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                              const Spacer(),
                              Text(u.createdAt?.formatted ?? '',
                                  style: const TextStyle(
                                      color: AppColors.textTertiary,
                                      fontSize: 11)),
                            ]),
                            if (u.note != null) ...[
                              const SizedBox(height: 4),
                              Text(u.note!,
                                  style: const TextStyle(
                                      fontSize: 12, height: 1.4)),
                            ],
                          ],
                        ),
                      ),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
