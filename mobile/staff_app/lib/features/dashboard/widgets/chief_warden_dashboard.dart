import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _overviewProvider =
    FutureProvider.autoDispose<InstitutionOverview>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user?.institutionId == null) throw Exception('No institution assigned');
  return ref.watch(analyticsApiProvider).getOverview(user!.institutionId!);
});

class ChiefWardenDashboard extends ConsumerWidget {
  final User? user;
  const ChiefWardenDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(_overviewProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('DormConnect Staff'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_overviewProvider),
          ),
        ],
      ),
      body: overviewAsync.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(
            message: e.toString(),
            onRetry: () => ref.invalidate(_overviewProvider)),
        data: (ov) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(_overviewProvider),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ov.institutionName,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800)),
                Text(user?.role.displayName ?? '',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 16),

                // Institution stats row
                DcCard(
                  child: Row(children: [
                    _StatPill('${ov.totalStudents}', 'Students',
                        AppColors.primary),
                    _StatPill('${ov.totalOut}', 'OUT', AppColors.warning),
                    _StatPill('${ov.onLeaveToday}', 'On Leave',
                        AppColors.info),
                    _StatPill('${ov.overdueReturns}', 'Overdue',
                        AppColors.error),
                  ]),
                ),
                const SizedBox(height: 16),

                // Health scores
                const Text('Hostel Health Scores',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 10),
                ...ov.hostels.map((h) => _HostelHealthRow(
                      hostel: h,
                      onTap: () => context.go('/home/analytics'),
                    )),
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
                        child: Text('Institution Analytics',
                            style:
                                TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textTertiary),
                    ]),
                  ),
                ),
                const SizedBox(height: 8),
                if (user?.role == UserRole.chiefWarden)
                  GestureDetector(
                    onTap: () => context.go('/home/staff'),
                    child: DcCard(
                      child: Row(children: [
                        const Icon(Icons.manage_accounts_outlined,
                            color: AppColors.primary),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text('Staff Management',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600)),
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

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatPill(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: color)),
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondary)),
        ]),
      );
}

class _HostelHealthRow extends StatelessWidget {
  final HostelHealth hostel;
  final VoidCallback onTap;
  const _HostelHealthRow({required this.hostel, required this.onTap});

  Color get _color => hostel.healthScore >= 80
      ? AppColors.success
      : hostel.healthScore >= 60
          ? AppColors.warning
          : AppColors.error;

  String get _emoji => hostel.healthScore >= 80
      ? '✅'
      : hostel.healthScore >= 60
          ? '⚠️'
          : '🔴';

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: DcCard(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
            child: Row(children: [
              SizedBox(
                width: 80,
                child: Text(hostel.hostelName,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: hostel.healthScore / 100,
                    backgroundColor: AppColors.border,
                    valueColor:
                        AlwaysStoppedAnimation(_color),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('${hostel.healthScore.toInt()}%',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _color)),
              const SizedBox(width: 4),
              Text(_emoji, style: const TextStyle(fontSize: 14)),
            ]),
          ),
        ),
      );
}
