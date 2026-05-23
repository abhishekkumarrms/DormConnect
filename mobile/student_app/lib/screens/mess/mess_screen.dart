import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _messMenuProvider = FutureProvider<List<MessMenu>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user?.hostelId == null) return [];
  return ref.watch(messApiProvider).getMenu(user!.hostelId!);
});

class MessScreen extends ConsumerWidget {
  const MessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menu = ref.watch(_messMenuProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mess Menu'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_messMenuProvider)),
        ],
      ),
      body: menu.when(
        loading: () => const DcLoading(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (items) {
          if (items.isEmpty) {
            return const DcEmptyState(
                icon: Icons.restaurant_menu_outlined,
                title: 'No menu set');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final m = items[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DcCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.date,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 8),
                      if (m.breakfast != null)
                        _MealRow(label: 'Breakfast', items: m.breakfast!),
                      if (m.lunch != null)
                        _MealRow(label: 'Lunch', items: m.lunch!),
                      if (m.snacks != null)
                        _MealRow(label: 'Snacks', items: m.snacks!),
                      if (m.dinner != null)
                        _MealRow(label: 'Dinner', items: m.dinner!),
                      if (m.breakfast == null &&
                          m.lunch == null &&
                          m.snacks == null &&
                          m.dinner == null)
                        const Text('—',
                            style: TextStyle(color: AppColors.textTertiary)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _MealRow extends StatelessWidget {
  final String label;
  final String items;
  const _MealRow({required this.label, required this.items});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          DcBadge(label: label),
          const SizedBox(width: 8),
          Expanded(child: Text(items, style: const TextStyle(fontSize: 13))),
        ]),
      );
}
