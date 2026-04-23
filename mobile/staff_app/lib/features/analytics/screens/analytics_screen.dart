import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/role_permissions.dart';

final _hostelHealthAnalyticsProvider =
    FutureProvider.autoDispose.family<HostelHealth, String>(
        (ref, hostelId) async =>
            ref.watch(analyticsApiProvider).getHostelHealth(hostelId));

final _overviewAnalyticsProvider =
    FutureProvider.autoDispose.family<InstitutionOverview, String>(
        (ref, institutionId) async =>
            ref.watch(analyticsApiProvider).getOverview(institutionId));

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final role = user?.role ?? UserRole.warden;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (user?.hostelId != null) {
                ref.invalidate(
                    _hostelHealthAnalyticsProvider(user!.hostelId!));
              }
              if (user?.institutionId != null) {
                ref.invalidate(_overviewAnalyticsProvider(
                    user!.institutionId!));
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user?.hostelId != null &&
                RolePermissions.canViewAnalytics(role))
              _HostelHealthSection(hostelId: user!.hostelId!),
            if (user?.institutionId != null &&
                RolePermissions.canViewAllHostels(role))
              _InstitutionSection(
                  institutionId: user!.institutionId!),
          ],
        ),
      ),
    );
  }
}

class _HostelHealthSection extends ConsumerWidget {
  final String hostelId;
  const _HostelHealthSection({required this.hostelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async =
        ref.watch(_hostelHealthAnalyticsProvider(hostelId));
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) =>
          DcErrorState(message: e.toString()),
      data: (h) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(h.hostelName,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),

          // Health score donut
          _HealthScoreDonut(score: h.healthScore),
          const SizedBox(height: 16),

          // Stats bar chart
          _StatsBarChart(health: h),
          const SizedBox(height: 16),

          // Stats grid
          _StatGrid(items: [
            ('Total Students', '${h.totalStudents}', AppColors.primary),
            ('Currently Out', '${h.currentOut}', AppColors.warning),
            ('Complaints', '${h.complaintsPending}', AppColors.error),
            ('Maintenance', '${h.maintenancePending}', AppColors.warning),
            if (h.pendingLeaves != null)
              ('Leaves Pending', '${h.pendingLeaves}', AppColors.info),
            if (h.pendingEnrollments != null)
              ('Enrollments', '${h.pendingEnrollments}', AppColors.success),
          ]),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _HealthScoreDonut extends StatelessWidget {
  final double score;
  const _HealthScoreDonut({required this.score});

  Color get _color {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return DcCard(
      child: Column(children: [
        const Text('Health Score',
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  startDegreeOffset: -90,
                  sections: [
                    PieChartSectionData(
                      value: score,
                      color: _color,
                      radius: 20,
                      title: '',
                    ),
                    PieChartSectionData(
                      value: 100 - score,
                      color: AppColors.surfaceVariant,
                      radius: 20,
                      title: '',
                    ),
                  ],
                  centerSpaceRadius: 50,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${score.toStringAsFixed(0)}',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: _color),
                  ),
                  const Text('/100',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class _StatsBarChart extends StatelessWidget {
  final HostelHealth health;
  const _StatsBarChart({required this.health});

  @override
  Widget build(BuildContext context) {
    final bars = [
      ('Out', health.currentOut.toDouble(), AppColors.warning),
      ('Complaints', health.complaintsPending.toDouble(), AppColors.error),
      ('Maintenance', health.maintenancePending.toDouble(), AppColors.primary),
      if (health.pendingLeaves != null)
        ('Leaves', health.pendingLeaves!.toDouble(), AppColors.info),
    ];

    return DcCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pending Items',
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: bars
                        .map((b) => b.$2)
                        .reduce((a, b) => a > b ? a : b) *
                    1.3,
                barGroups: bars
                    .asMap()
                    .entries
                    .map((e) => BarChartGroupData(
                          x: e.key,
                          barRods: [
                            BarChartRodData(
                              toY: e.value.$2,
                              color: e.value.$3,
                              width: 20,
                              borderRadius:
                                  const BorderRadius.vertical(
                                      top: Radius.circular(4)),
                            ),
                          ],
                        ))
                    .toList(),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        final idx = v.toInt();
                        if (idx < 0 || idx >= bars.length) {
                          return const SizedBox();
                        }
                        return Text(bars[idx].$1,
                            style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary));
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  final List<(String, String, Color)> items;
  const _StatGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.3,
      children: items
          .map((item) => DcCard(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.$2,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: item.$3)),
                    const SizedBox(height: 2),
                    Text(item.$1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _InstitutionSection extends ConsumerWidget {
  final String institutionId;
  const _InstitutionSection({required this.institutionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async =
        ref.watch(_overviewAnalyticsProvider(institutionId));
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) => DcErrorState(message: e.toString()),
      data: (overview) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(overview.institutionName,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          _StatGrid(items: [
            ('Total Students', '${overview.totalStudents}',
                AppColors.primary),
            ('Out Now', '${overview.totalOut}', AppColors.warning),
            ('On Leave', '${overview.onLeaveToday}', AppColors.info),
            ('Overdue', '${overview.overdueReturns}',
                AppColors.error),
          ]),
          const SizedBox(height: 16),
          const Text('Hostel Health',
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          ...overview.hostels.map((h) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DcCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(children: [
                    Row(children: [
                      Expanded(
                        child: Text(h.hostelName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                      ),
                      Text(
                        '${h.healthScore.toStringAsFixed(0)}/100',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _scoreColor(h.healthScore)),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: h.healthScore / 100,
                      backgroundColor:
                          AppColors.surfaceVariant,
                      color: _scoreColor(h.healthScore),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 6),
                    Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          _Mini('${h.totalStudents}', 'students'),
                          _Mini('${h.currentOut}', 'out'),
                          _Mini(
                              '${h.complaintsPending}', 'complaints'),
                          _Mini(
                              '${h.maintenancePending}', 'maint'),
                        ]),
                  ]),
                ),
              )),
        ],
      ),
    );
  }

  Color _scoreColor(double s) {
    if (s >= 80) return AppColors.success;
    if (s >= 60) return AppColors.warning;
    return AppColors.error;
  }
}

class _Mini extends StatelessWidget {
  final String value;
  final String label;
  const _Mini(this.value, this.label);

  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 10)),
      ]);
}
