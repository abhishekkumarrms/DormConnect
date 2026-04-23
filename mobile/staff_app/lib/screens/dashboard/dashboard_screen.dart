import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _statsProvider = FutureProvider<HostelHealth?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user?.hostelId == null) return null;
  return ref.watch(analyticsApiProvider).getHostelHealth(user!.hostelId!);
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final stats = ref.watch(_statsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${user?.name.split(' ').first ?? 'Staff'}'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_statsProvider)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(_statsProvider),
        child: stats.when(
          loading: () => const DcLoading(),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (s) => s == null
              ? const DcEmptyState(
                  icon: Icons.dashboard_outlined,
                  title: 'No hostel assigned',
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HealthScoreCard(score: s.healthScore, name: s.hostelName),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.4,
                        children: [
                          DcStatCard(
                              label: 'Total Students',
                              value: '${s.totalStudents}',
                              icon: Icons.people_outline,
                              iconColor: AppColors.primary),
                          DcStatCard(
                              label: 'Currently In',
                              value: '${s.totalStudents - s.currentOut}',
                              icon: Icons.home_outlined,
                              iconColor: AppColors.success),
                          DcStatCard(
                              label: 'Outside',
                              value: '${s.currentOut}',
                              icon: Icons.directions_walk_outlined,
                              iconColor: AppColors.warning),
                          DcStatCard(
                              label: 'Pending Leaves',
                              value: '${s.pendingLeaves ?? 0}',
                              icon: Icons.beach_access_outlined,
                              iconColor: AppColors.info),
                          DcStatCard(
                              label: 'Open Complaints',
                              value: '${s.complaintsPending}',
                              icon: Icons.report_problem_outlined,
                              iconColor: AppColors.error),
                          DcStatCard(
                              label: 'Maintenance',
                              value: '${s.maintenancePending}',
                              icon: Icons.build_outlined,
                              iconColor: AppColors.secondary),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _HealthScoreCard extends StatelessWidget {
  final double score;
  final String name;
  const _HealthScoreCard({required this.score, required this.name});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.healthScore(score);
    return DcCard(
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 6,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Text(score.toStringAsFixed(0),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: color)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 4),
                const Text('Health Score',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                    score >= 80
                        ? 'Excellent'
                        : score >= 60
                            ? 'Good'
                            : 'Needs Attention',
                    style: TextStyle(color: color, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
