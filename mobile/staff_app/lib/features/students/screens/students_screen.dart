import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/role_permissions.dart';

final _allStudentsProvider =
    FutureProvider.autoDispose<List<Student>>((ref) async =>
        ref.watch(studentApiProvider).list(limit: 200));

final _pendingEnrollProvider =
    FutureProvider.autoDispose<List<Student>>((ref) async =>
        ref.watch(studentApiProvider).pendingEnrollments());

class StudentsScreen extends ConsumerStatefulWidget {
  const StudentsScreen({super.key});

  @override
  ConsumerState<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends ConsumerState<StudentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String? _statusFilter; // null=all, 'inHostel', 'outHostel'
  String _search = '';

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  List<Student> _apply(List<Student> list) {
    var result = list
        .where((s) => s.enrollmentStatus == EnrollmentStatus.active)
        .toList();
    if (_statusFilter != null) {
      result = result.where((s) => s.currentStatus.name == _statusFilter).toList();
    }
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      result = result
          .where((s) =>
              s.name.toLowerCase().contains(q) ||
              s.rollNumber.toLowerCase().contains(q) ||
              (s.roomNumber?.toLowerCase().contains(q) ?? false))
          .toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final role = user?.role ?? UserRole.caretaker;
    final studentsAsync = ref.watch(_allStudentsProvider);
    final pendingAsync = ref.watch(_pendingEnrollProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: AppColors.secondary,
          tabs: const [Tab(text: 'Active'), Tab(text: 'Enrollment')],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search name, room, roll…',
                    prefixIcon:
                        Icon(Icons.search_rounded, size: 18),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _search = v),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    _FChip('All', null, _statusFilter,
                        (v) => setState(() => _statusFilter = v)),
                    _FChip('IN', 'inHostel', _statusFilter,
                        (v) => setState(() => _statusFilter = v)),
                    _FChip('OUT', 'outHostel', _statusFilter,
                        (v) => setState(() => _statusFilter = v)),
                  ]),
                ),
              ]),
            ),
            Expanded(
              child: studentsAsync.when(
                loading: () => const DcLoading(),
                error: (e, _) => DcErrorState(
                    message: e.toString(),
                    onRetry: () => ref.invalidate(_allStudentsProvider)),
                data: (list) {
                  final filtered = _apply(list);
                  if (filtered.isEmpty) {
                    return const DcEmptyState(
                        icon: Icons.people_outline,
                        title: 'No students found');
                  }
                  return RefreshIndicator(
                    onRefresh: () async =>
                        ref.invalidate(_allStudentsProvider),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 6),
                      itemBuilder: (_, i) =>
                          _StudentCard(student: filtered[i]),
                    ),
                  );
                },
              ),
            ),
          ]),

          pendingAsync.when(
            loading: () => const DcLoading(),
            error: (e, _) => DcErrorState(message: e.toString()),
            data: (list) {
              if (list.isEmpty) {
                return const DcEmptyState(
                    icon: Icons.check_circle_outline,
                    title: 'No pending enrollments');
              }
              return RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(_pendingEnrollProvider),
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (_, i) => _EnrollCard(
                    student: list[i],
                    canAct: RolePermissions.canManageEnrollment(role),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FChip extends StatelessWidget {
  final String label;
  final String? value;
  final String? current;
  final ValueChanged<String?> onChanged;
  const _FChip(this.label, this.value, this.current, this.onChanged);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 6),
        child: ChoiceChip(
          label: Text(label),
          selected: current == value,
          selectedColor: AppColors.primary.withOpacity(0.15),
          onSelected: (_) => onChanged(value),
        ),
      );
}

class _StudentCard extends StatelessWidget {
  final Student student;
  const _StudentCard({required this.student});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.go('/students/${student.id}'),
        child: DcCard(
          child: Row(children: [
            DcAvatar(name: student.name, radius: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    '${student.rollNumber}  ·  Room ${student.roomNumber ?? '—'}',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            DcStatusChip(status: student.currentStatus.name),
          ]),
        ),
      );
}

class _EnrollCard extends StatelessWidget {
  final Student student;
  final bool canAct;
  const _EnrollCard({required this.student, required this.canAct});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.go('/students/enroll/${student.id}'),
        child: DcCard(
          child: Row(children: [
            DcAvatar(name: student.name, radius: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(student.rollNumber,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                  Text(
                    'Applied ${student.createdAt?.formatted ?? ''}',
                    style: const TextStyle(
                        color: AppColors.textTertiary, fontSize: 11),
                  ),
                ],
              ),
            ),
            if (canAct)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Review',
                    style: TextStyle(
                        color: AppColors.warning,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
          ]),
        ),
      );
}
