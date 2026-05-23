import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _mealTypeProvider = StateProvider<String>((ref) => 'LUNCH');

final _messCountProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user?.hostelId == null) return null;
  final mealType = ref.watch(_mealTypeProvider);
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  return ref.watch(messApiProvider).getCount(user!.hostelId!, today, mealType);
});

class MessCountScreen extends ConsumerWidget {
  const MessCountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealType = ref.watch(_mealTypeProvider);
    final count = ref.watch(_messCountProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mess Count')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'BREAKFAST', label: Text('Breakfast')),
                ButtonSegment(value: 'LUNCH', label: Text('Lunch')),
                ButtonSegment(value: 'DINNER', label: Text('Dinner')),
              ],
              selected: {mealType},
              onSelectionChanged: (s) =>
                  ref.read(_mealTypeProvider.notifier).state = s.first,
            ),
          ),
          Expanded(
            child: count.when(
              loading: () => const DcLoading(),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (c) => c == null
                  ? const DcEmptyState(
                      icon: Icons.restaurant_menu_outlined,
                      title: 'No count data',
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _CountCard(
                            label: 'Expected Count',
                            value: (c['expected_count'] as num?)?.toInt() ?? 0,
                            color: AppColors.primary,
                            icon: Icons.people,
                          ),
                          const SizedBox(height: 12),
                          Row(children: [
                            Expanded(
                              child: _CountCard(
                                label: 'Total Students',
                                value: (c['total_students'] as num?)?.toInt() ?? 0,
                                color: AppColors.info,
                                icon: Icons.group,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _CountCard(
                                label: 'On Leave',
                                value: (c['on_leave'] as num?)?.toInt() ?? 0,
                                color: AppColors.warning,
                                icon: Icons.beach_access,
                              ),
                            ),
                          ]),
                          const SizedBox(height: 12),
                          Row(children: [
                            Expanded(
                              child: _CountCard(
                                label: 'Mess Off',
                                value: (c['mess_off'] as num?)?.toInt() ?? 0,
                                color: AppColors.error,
                                icon: Icons.no_meals,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Container()),
                          ]),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;
  const _CountCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => DcCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text('$value',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: color)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      );
}
