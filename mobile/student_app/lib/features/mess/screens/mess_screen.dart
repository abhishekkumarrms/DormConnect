import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final _studentForMessProvider = FutureProvider<Student>((ref) async =>
    ref.watch(studentApiProvider).getProfile());

final _messMenuProvider = FutureProvider<List<MessMenu>>((ref) async {
  final student = await ref.watch(_studentForMessProvider.future);
  return ref.watch(messApiProvider).getMenu(student.hostelId);
});

class MessScreen extends ConsumerWidget {
  const MessScreen({super.key});

  void _refresh(WidgetRef ref) {
    ref.invalidate(_studentForMessProvider);
    ref.invalidate(_messMenuProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsync = ref.watch(_messMenuProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mess Menu'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refresh(ref),
          ),
        ],
      ),
      body: menuAsync.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(
            message: e.toString(),
            onRetry: () => _refresh(ref)),
        data: (menus) {
          if (menus.isEmpty) {
            return const DcEmptyState(
              icon: Icons.restaurant_outlined,
              title: 'No menu available',
              subtitle: 'Weekly menu not yet published',
            );
          }
          final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
          return RefreshIndicator(
            onRefresh: () async => _refresh(ref),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menus.length,
              itemBuilder: (_, i) {
                final menu = menus[i];
                final isToday = menu.date == todayStr;
                return _DayMenuCard(menu: menu, isToday: isToday);
              },
            ),
          );
        },
      ),
    );
  }
}

class _DayMenuCard extends StatelessWidget {
  final MessMenu menu;
  final bool isToday;
  const _DayMenuCard({required this.menu, required this.isToday});

  String _formatDate(String dateStr) {
    try {
      final dt = DateFormat('yyyy-MM-dd').parse(dateStr);
      return DateFormat('EEEE, d MMM').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DcCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isToday
                      ? AppColors.primary
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isToday ? 'Today' : _formatDate(menu.date),
                  style: TextStyle(
                    color:
                        isToday ? Colors.white : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (!isToday) ...[
                const SizedBox(width: 8),
                Text(
                  _formatDate(menu.date),
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ]),
            const SizedBox(height: 12),
            _MealRow(
              mealName: 'Breakfast',
              icon: Icons.free_breakfast_outlined,
              value: menu.breakfast,
            ),
            const Divider(height: 16),
            _MealRow(
              mealName: 'Lunch',
              icon: Icons.lunch_dining_outlined,
              value: menu.lunch,
            ),
            const Divider(height: 16),
            _MealRow(
              mealName: 'Snacks',
              icon: Icons.cookie_outlined,
              value: menu.snacks,
            ),
            const Divider(height: 16),
            _MealRow(
              mealName: 'Dinner',
              icon: Icons.dinner_dining_outlined,
              value: menu.dinner,
            ),
          ],
        ),
      ),
    );
  }
}

class _MealRow extends StatelessWidget {
  final String mealName;
  final IconData icon;
  final String? value;
  const _MealRow(
      {required this.mealName, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          SizedBox(
            width: 70,
            child: Text(mealName,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(
              value ?? '—',
              style: const TextStyle(fontSize: 12, height: 1.4),
            ),
          ),
        ],
      );
}
