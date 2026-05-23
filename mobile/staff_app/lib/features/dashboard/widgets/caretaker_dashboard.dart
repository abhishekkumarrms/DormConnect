import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final _hostelHealthProvider =
    FutureProvider.autoDispose<HostelHealth>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user?.hostelId == null) throw Exception('No hostel assigned');
  return ref.watch(analyticsApiProvider).getHostelHealth(user!.hostelId!);
});

final _messCountProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user?.hostelId == null) return {};
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  return ref.watch(messApiProvider).getCount(user!.hostelId!, today, 'lunch');
});

final _visitorsInsideProvider =
    FutureProvider.autoDispose<List<Visitor>>((ref) async =>
        ref.watch(visitorApiProvider).getActive());

class CaretakerDashboard extends ConsumerWidget {
  final User? user;
  const CaretakerDashboard({super.key, required this.user});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthAsync = ref.watch(_hostelHealthProvider);
    final countAsync = ref.watch(_messCountProvider);
    final visitorsAsync = ref.watch(_visitorsInsideProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('DormConnect Staff'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(_hostelHealthProvider);
              ref.invalidate(_messCountProvider);
              ref.invalidate(_visitorsInsideProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(_hostelHealthProvider);
          ref.invalidate(_messCountProvider);
          ref.invalidate(_visitorsInsideProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                '${_greeting()}, ${user?.name.split(' ').first ?? 'Staff'}',
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800),
              ),
              Text(
                'Caretaker · ${user?.hostelId != null ? 'Hostel' : 'Assigned Hostel'}',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Stats grid
              healthAsync.when(
                loading: () => const _StatsGridSkeleton(),
                error: (e, _) => DcErrorState(
                    message: e.toString(),
                    onRetry: () =>
                        ref.invalidate(_hostelHealthProvider)),
                data: (h) => _StatsGrid(health: h),
              ),
              const SizedBox(height: 16),

              // Mess count
              DcCard(
                child: countAsync.when(
                  loading: () => const Row(children: [
                    Icon(Icons.restaurant_outlined,
                        color: AppColors.textSecondary),
                    SizedBox(width: 8),
                    Text('Loading mess count...',
                        style:
                            TextStyle(color: AppColors.textSecondary)),
                  ]),
                  error: (_, __) => const Row(children: [
                    Icon(Icons.restaurant_outlined,
                        color: AppColors.textTertiary),
                    SizedBox(width: 8),
                    Text('Mess count unavailable',
                        style:
                            TextStyle(color: AppColors.textTertiary)),
                  ]),
                  data: (c) => Row(children: [
                    const Icon(Icons.restaurant_outlined,
                        color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Expected Mess Today: ${c['expected_count'] ?? '—'}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 8),

              // Visitors
              DcCard(
                child: visitorsAsync.when(
                  loading: () => const Row(children: [
                    Icon(Icons.person_pin_outlined,
                        color: AppColors.textSecondary),
                    SizedBox(width: 8),
                    Text('Loading visitors...',
                        style:
                            TextStyle(color: AppColors.textSecondary)),
                  ]),
                  error: (_, __) => const Row(children: [
                    Icon(Icons.person_pin_outlined,
                        color: AppColors.textTertiary),
                    SizedBox(width: 8),
                    Text('Visitor data unavailable',
                        style:
                            TextStyle(color: AppColors.textTertiary)),
                  ]),
                  data: (list) => GestureDetector(
                    onTap: () => context.go('/home/visitors'),
                    child: Row(children: [
                      const Icon(Icons.person_pin_outlined,
                          color: AppColors.info),
                      const SizedBox(width: 8),
                      Text(
                        'Visitors Inside: ${list.length}',
                        style:
                            const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textTertiary, size: 18),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Quick actions
              const Text('Quick Actions',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 10),
              Row(children: [
                _QuickAction(
                  icon: Icons.people_outline,
                  label: 'Students',
                  color: AppColors.primary,
                  onTap: () => context.go('/home/students'),
                ),
                const SizedBox(width: 10),
                _QuickAction(
                  icon: Icons.sensor_door_outlined,
                  label: 'Gate',
                  color: AppColors.info,
                  onTap: () => context.go('/home/gate'),
                ),
                const SizedBox(width: 10),
                _QuickAction(
                  icon: Icons.handshake_outlined,
                  label: 'Handover',
                  color: AppColors.warning,
                  onTap: () => context.go('/shift/handover'),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final HostelHealth health;
  const _StatsGrid({required this.health});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.0,
      children: [
        _StatCard(
          value: health.complaintsPending.toString(),
          label: 'Complaints',
          sublabel: 'Pending',
          color: AppColors.error,
          onTap: () => context.go('/home/complaints'),
        ),
        _StatCard(
          value: health.maintenancePending.toString(),
          label: 'Maintenance',
          sublabel: 'Pending',
          color: AppColors.warning,
          onTap: () => context.go('/home/maintenance'),
        ),
        _StatCard(
          value: (health.pendingEnrollments ?? 0).toString(),
          label: 'Enrollment',
          sublabel: 'Pending',
          color: AppColors.info,
          onTap: () => context.go('/home/students'),
        ),
        _StatCard(
          value: health.currentOut.toString(),
          label: 'Students',
          sublabel: 'OUT',
          color: AppColors.textSecondary,
          onTap: () => context.go('/home/gate'),
        ),
        _StatCard(
          value: (health.pendingLeaves ?? 0).toString(),
          label: 'Leaves',
          sublabel: 'Pending',
          color: AppColors.primary,
          onTap: () => context.go('/home/leaves'),
        ),
        _StatCard(
          value: '${health.healthScore.toInt()}%',
          label: 'Health',
          sublabel: 'Score',
          color: health.healthScore >= 80
              ? AppColors.success
              : health.healthScore >= 60
                  ? AppColors.warning
                  : AppColors.error,
          onTap: () {},
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback onTap;
  const _StatCard({
    required this.value,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: color)),
              const SizedBox(height: 2),
              Text(label,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              Text(sublabel,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textTertiary)),
            ],
          ),
        ),
      );
}

class _StatsGridSkeleton extends StatelessWidget {
  const _StatsGridSkeleton();

  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
        children: List.generate(
          6,
          (_) => Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      );
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(height: 6),
                Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color)),
              ],
            ),
          ),
        ),
      );
}
