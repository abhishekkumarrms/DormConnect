import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/role_permissions.dart';

final _studentDetailProvider =
    FutureProvider.autoDispose.family<Student, String>((ref, id) async =>
        ref.watch(studentApiProvider).getById(id));

final _studentMovementsProvider =
    FutureProvider.autoDispose.family<List<MovementLog>, String>(
        (ref, studentId) async =>
            ref.watch(gateApiProvider).getHistory(limit: 20));

final _studentLeavesProvider =
    FutureProvider.autoDispose.family<List<LeaveApplication>, String>(
        (ref, studentId) async =>
            ref.watch(leaveApiProvider).list(limit: 20));

final _studentComplaintsProvider =
    FutureProvider.autoDispose.family<List<Complaint>, String>(
        (ref, studentId) async =>
            ref.watch(complaintApiProvider).list(limit: 20));

class StudentDetailScreen extends ConsumerStatefulWidget {
  final String studentId;
  const StudentDetailScreen({super.key, required this.studentId});

  @override
  ConsumerState<StudentDetailScreen> createState() =>
      _StudentDetailScreenState();
}

class _StudentDetailScreenState extends ConsumerState<StudentDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final role = user?.role ?? UserRole.caretaker;
    final studentAsync =
        ref.watch(_studentDetailProvider(widget.studentId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(_studentDetailProvider(widget.studentId)),
          ),
        ],
      ),
      body: studentAsync.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(message: e.toString()),
        data: (student) => Column(
          children: [
            // Profile header
            _ProfileHeader(
                student: student, role: role),
            // Tabs
            TabBar(
              controller: _tab,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(text: 'Info'),
                Tab(text: 'Movements'),
                Tab(text: 'Complaints'),
                Tab(text: 'Leaves'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _InfoTab(student: student, role: role),
                  _MovementsTab(studentId: widget.studentId),
                  _ComplaintsTab(studentId: widget.studentId),
                  _LeavesTab(studentId: widget.studentId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends ConsumerWidget {
  final Student student;
  final UserRole role;
  const _ProfileHeader({required this.student, required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        padding: const EdgeInsets.all(16),
        color: AppColors.primary,
        child: Row(children: [
          DcAvatar(name: student.name, radius: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                Text(
                  '${student.rollNumber}  ·  Room ${student.roomNumber ?? '—'}',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13),
                ),
              ],
            ),
          ),
          DcStatusChip(status: student.currentStatus.name),
        ]),
      );
}

class _InfoTab extends ConsumerStatefulWidget {
  final Student student;
  final UserRole role;
  const _InfoTab({required this.student, required this.role});

  @override
  ConsumerState<_InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends ConsumerState<_InfoTab> {
  bool _editingRoom = false;
  late TextEditingController _roomCtrl;

  @override
  void initState() {
    super.initState();
    _roomCtrl = TextEditingController(text: widget.student.roomNumber ?? '');
  }

  @override
  void dispose() {
    _roomCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.student;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DcCard(
            child: Column(children: [
              _Row('Phone', s.phone),
              if (s.email != null) _Row('Email', s.email!),
              if (s.course != null) _Row('Course', s.course!),
              if (s.year != null) _Row('Year', 'Year ${s.year}'),
              _Row('Enrollment', s.enrollmentStatus.name.snakeToTitle),
              const Divider(height: 16),
              Row(children: [
                const Text('Room',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
                const Spacer(),
                if (_editingRoom && RolePermissions.canEditStudentProfile(widget.role)) ...[
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _roomCtrl,
                      decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          border: OutlineInputBorder()),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => setState(() => _editingRoom = false),
                    child: const Icon(Icons.check_rounded,
                        color: AppColors.success, size: 20),
                  ),
                ] else ...[
                  Text(s.roomNumber ?? '—',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  if (RolePermissions.canEditStudentProfile(widget.role)) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _editingRoom = true),
                      child: const Icon(Icons.edit_outlined,
                          size: 16, color: AppColors.textTertiary),
                    ),
                  ],
                ],
              ]),
            ]),
          ),
          const SizedBox(height: 12),
          if (s.guardianName != null)
            DcCard(
              child: Column(children: [
                const Text('Guardian',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        fontSize: 12)),
                const SizedBox(height: 8),
                _Row('Name', s.guardianName!),
                if (s.guardianPhone != null)
                  _Row('Phone', s.guardianPhone!),
              ]),
            ),
          const SizedBox(height: 20),
          if (RolePermissions.canManageEnrollment(widget.role) &&
              s.enrollmentStatus == EnrollmentStatus.active)
            DcButton(
              label: 'Permanent Checkout',
              outlined: true,
              color: AppColors.error,
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Permanent Checkout'),
                  content: Text(
                      'Remove ${s.name} from hostel permanently?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // checkout: reject with checkout reason
                          ref
                              .read(studentApiProvider)
                              .reject(s.id, reason: 'checkout');
                          context.go('/home/students');
                        },
                        child: const Text('Confirm',
                            style: TextStyle(color: AppColors.error))),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ]),
      );
}

class _MovementsTab extends ConsumerWidget {
  final String studentId;
  const _MovementsTab({required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_studentMovementsProvider(studentId));
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) => DcErrorState(message: e.toString()),
      data: (list) => list.isEmpty
          ? const DcEmptyState(
              icon: Icons.history_rounded, title: 'No movements')
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (_, i) {
                final m = list[i];
                final isOut = m.type == MovementType.out;
                return DcCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    Icon(
                      isOut
                          ? Icons.arrow_circle_up_rounded
                          : Icons.arrow_circle_down_rounded,
                      color: isOut ? AppColors.warning : AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isOut ? 'Left' : 'Returned',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(m.createdAt?.formatted ?? '',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ]),
                );
              },
            ),
    );
  }
}

class _ComplaintsTab extends ConsumerWidget {
  final String studentId;
  const _ComplaintsTab({required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_studentComplaintsProvider(studentId));
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) => DcErrorState(message: e.toString()),
      data: (list) => list.isEmpty
          ? const DcEmptyState(
              icon: Icons.report_outlined, title: 'No complaints')
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (_, i) {
                final c = list[i];
                return GestureDetector(
                  onTap: () => context.go('/complaint/${c.id}'),
                  child: DcCard(
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.category.name.snakeToTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                            Text(c.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                      DcStatusChip(status: c.status.name),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}

class _LeavesTab extends ConsumerWidget {
  final String studentId;
  const _LeavesTab({required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_studentLeavesProvider(studentId));
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) => DcErrorState(message: e.toString()),
      data: (list) => list.isEmpty
          ? const DcEmptyState(
              icon: Icons.beach_access_outlined, title: 'No leaves')
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (_, i) {
                final l = list[i];
                return GestureDetector(
                  onTap: () => context.go('/leave/${l.id}'),
                  child: DcCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          DcBadge(label: l.leaveType.name),
                          const SizedBox(width: 8),
                          DcStatusChip(status: l.status.name),
                        ]),
                        const SizedBox(height: 6),
                        Text(
                          '${l.fromDate.formatted} → ${l.toDate.formatted}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
