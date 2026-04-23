import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _wardenHealthProvider =
    FutureProvider.autoDispose<HostelHealth>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user?.hostelId == null) throw Exception('No hostel assigned');
  return ref.watch(analyticsApiProvider).getHostelHealth(user!.hostelId!);
});

class WardenDashboard extends ConsumerWidget {
  final User? user;
  const WardenDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthAsync = ref.watch(_wardenHealthProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('DormConnect Staff'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_wardenHealthProvider),
          ),
        ],
      ),
      body: healthAsync.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(
            message: e.toString(),
            onRetry: () => ref.invalidate(_wardenHealthProvider)),
        data: (h) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(_wardenHealthProvider),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  h.hostelName,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800),
                ),
                Text(
                  user?.role.displayName ?? '',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 20),

                // Overview card
                DcCard(
                  child: Column(
                    children: [
                      Row(children: [
                        _OverviewItem(
                          label: 'Total Students',
                          value: h.totalStudents.toString(),
                          color: AppColors.primary,
                        ),
                        _OverviewItem(
                          label: 'Currently OUT',
                          value: h.currentOut.toString(),
                          color: AppColors.warning,
                        ),
                        _OverviewItem(
                          label: 'Health Score',
                          value: '${h.healthScore.toInt()}%',
                          color: h.healthScore >= 80
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Complaints section
                _SectionCard(
                  title: 'Complaints',
                  icon: Icons.report_problem_outlined,
                  color: AppColors.error,
                  items: [
                    ('Pending', h.complaintsPending.toString()),
                  ],
                  onTap: () => context.go('/home/complaints'),
                ),
                const SizedBox(height: 8),

                // Maintenance section
                _SectionCard(
                  title: 'Maintenance',
                  icon: Icons.build_outlined,
                  color: AppColors.warning,
                  items: [
                    ('Pending', h.maintenancePending.toString()),
                  ],
                  onTap: () => context.go('/home/maintenance'),
                ),
                const SizedBox(height: 8),

                // Leaves section
                _SectionCard(
                  title: 'Leaves',
                  icon: Icons.beach_access_outlined,
                  color: AppColors.primary,
                  items: [
                    ('Pending Approval', (h.pendingLeaves ?? 0).toString()),
                  ],
                  onTap: () => context.go('/home/leaves'),
                ),
                const SizedBox(height: 16),

                // Analytics shortcut
                GestureDetector(
                  onTap: () => context.go('/home/analytics'),
                  child: DcCard(
                    child: Row(children: [
                      const Icon(Icons.bar_chart_rounded,
                          color: AppColors.primary),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text('View Hostel Analytics',
                            style:
                                TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textTertiary),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _OverviewItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color)),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      );
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<(String, String)> items;
  final VoidCallback onTap;
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: DcCard(
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  for (final (label, val) in items)
                    Text('$label: $val',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textTertiary),
          ]),
        ),
      );
}
