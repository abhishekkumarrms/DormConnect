import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _enrollmentFilterProvider = StateProvider<String?>((ref) => null);

final _studentsProvider = FutureProvider<List<Student>>((ref) async {
  final user = ref.watch(currentUserProvider);
  final filter = ref.watch(_enrollmentFilterProvider);
  return ref.watch(studentApiProvider).list(
        hostelId: user?.hostelId,
        enrollmentStatus: filter,
      );
});

class StudentListScreen extends ConsumerWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(_studentsProvider);
    final filter = ref.watch(_enrollmentFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_studentsProvider)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [null, 'PENDING', 'APPROVED', 'REJECTED'].map((f) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f ?? 'All'),
                    selected: filter == f,
                    onSelected: (_) => ref
                        .read(_enrollmentFilterProvider.notifier)
                        .state = f,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: students.when(
        loading: () => const DcShimmerList(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) => list.isEmpty
            ? const DcEmptyState(
                icon: Icons.people_outline, title: 'No students found')
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final s = list[i];
                  return DcCard(
                    onTap: () => context.go('/students/${s.id}'),
                    child: Row(
                      children: [
                        DcAvatar(
                            imageUrl: s.profilePhoto,
                            name: s.name,
                            radius: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              Text(
                                  '${s.rollNumber} • Room ${s.roomNumber ?? '—'}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            DcBadge(label: s.enrollmentStatus.name),
                            const SizedBox(height: 4),
                            DcBadge(label: s.currentStatus.name),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
