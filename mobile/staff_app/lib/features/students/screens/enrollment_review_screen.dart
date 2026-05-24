import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _hostelsProvider = FutureProvider<List<Hostel>>((ref) async {
  final resp = await ref.watch(apiClientProvider).get('/api/v1/hostels');
  final list = resp.data as List<dynamic>;
  return list.map((e) => Hostel.fromJson(e as Map<String, dynamic>)).toList();
});

final _enrollStudentProvider =
    FutureProvider.autoDispose.family<Student, String>((ref, id) async =>
        ref.watch(studentApiProvider).getById(id));

class EnrollmentReviewScreen extends ConsumerStatefulWidget {
  final String studentId;
  const EnrollmentReviewScreen({super.key, required this.studentId});

  @override
  ConsumerState<EnrollmentReviewScreen> createState() =>
      _EnrollmentReviewScreenState();
}

class _EnrollmentReviewScreenState
    extends ConsumerState<EnrollmentReviewScreen> {
  final _rejectReasonCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _rejectReasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _approve(Student student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Approval'),
        content: Text(
          'Confirm that you have physically verified ${student.name}\'s '
          'identity in person and approve their enrollment?',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes, Approve')),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _loading = true);
    try {
      await ref.read(studentApiProvider).approve(student.id);
      if (mounted) {
        DcSnackbar.success(context, '${student.name} enrolled successfully!');
        context.go('/home/students');
      }
    } catch (e) {
      if (mounted) DcSnackbar.error(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _reassignHostel(Student student) async {
    String? selectedHostelId;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final hostelsAsync = ref.watch(_hostelsProvider);
          return Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Reassign to Different Hostel',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text(
                  'Student will remain PENDING in the new hostel.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 16),
                hostelsAsync.when(
                  loading: () => const DcLoading(),
                  error: (e, _) => Text('Could not load hostels: $e',
                      style: const TextStyle(color: AppColors.error)),
                  data: (hostels) => DropdownButtonFormField<String>(
                    value: selectedHostelId,
                    decoration: InputDecoration(
                      labelText: 'New Hostel',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                    ),
                    items: hostels
                        .where((h) => h.id != student.hostelId)
                        .map((h) => DropdownMenuItem(value: h.id, child: Text(h.name)))
                        .toList(),
                    onChanged: (v) => setModalState(() => selectedHostelId = v),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: selectedHostelId == null
                        ? null
                        : () async {
                            Navigator.pop(ctx);
                            setState(() => _loading = true);
                            try {
                              await ref
                                  .read(studentApiProvider)
                                  .reassignHostel(student.id, selectedHostelId!);
                              if (mounted) {
                                DcSnackbar.success(context, 'Hostel reassigned.');
                                context.go('/home/students');
                              }
                            } catch (e) {
                              if (mounted) DcSnackbar.error(context, e.toString());
                            } finally {
                              if (mounted) setState(() => _loading = false);
                            }
                          },
                    child: const Text('Reassign Hostel'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _reject(Student student) async {
    _rejectReasonCtrl.clear();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reject Enrollment',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Provide a reason (student will be notified):',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 16),
            DcTextField(
              controller: _rejectReasonCtrl,
              label: 'Reason *',
              hint: 'e.g. Could not verify identity, wrong hostel',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                onPressed: () async {
                  if (_rejectReasonCtrl.text.trim().isEmpty) {
                    DcSnackbar.error(ctx, 'Please provide a reason.');
                    return;
                  }
                  Navigator.pop(ctx);
                  setState(() => _loading = true);
                  try {
                    await ref.read(studentApiProvider).reject(
                        student.id, reason: _rejectReasonCtrl.text.trim());
                    if (mounted) {
                      DcSnackbar.show(context, 'Enrollment rejected.');
                      context.go('/home/students');
                    }
                  } catch (e) {
                    if (mounted) DcSnackbar.error(context, e.toString());
                  } finally {
                    if (mounted) setState(() => _loading = false);
                  }
                },
                child: const Text('Reject Enrollment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentAsync = ref.watch(_enrollStudentProvider(widget.studentId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrollment Request'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: studentAsync.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(message: e.toString()),
        data: (student) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Physical verification reminder
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF59E0B)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFFD97706), size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Verify student identity in person before approving.',
                        style: TextStyle(color: Color(0xFF92400E), fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Student info
              DcCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Student Information',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(height: 12),
                    _InfoRow(Icons.person_outline, 'Name', student.name),
                    _InfoRow(Icons.phone_outlined, 'Phone', student.phone),
                    _InfoRow(Icons.badge_outlined, 'Roll Number', student.rollNumber),
                    _InfoRow(Icons.home_outlined, 'Hostel', student.hostelName ?? '—'),
                    _InfoRow(Icons.door_front_door_outlined, 'Room', student.roomNumber ?? '—'),
                    _InfoRow(Icons.schedule_outlined, 'Requested',
                        student.createdAt?.formatted ?? '—'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Guardian info
              DcCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Guardian Information',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(height: 12),
                    _InfoRow(Icons.people_outline, 'Name', student.guardianName ?? '—'),
                    _InfoRow(Icons.phone_outlined, 'Phone', student.guardianPhone ?? '—'),
                    _InfoRow(Icons.family_restroom_outlined, 'Relation',
                        student.guardianRelation ?? '—'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              if (student.enrollmentStatus == EnrollmentStatus.pending) ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.success,
                        minimumSize: const Size(double.infinity, 52)),
                    onPressed: _loading ? null : () => _approve(student),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Approve — Identity Verified',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        minimumSize: const Size(double.infinity, 52)),
                    onPressed: _loading ? null : () => _reassignHostel(student),
                    icon: const Icon(Icons.swap_horiz_rounded),
                    label: const Text('Wrong Hostel? Reassign',
                        style: TextStyle(fontSize: 15)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        minimumSize: const Size(double.infinity, 52)),
                    onPressed: _loading ? null : () => _reject(student),
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Reject', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            SizedBox(
              width: 90,
              child: Text(label,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
            ),
            Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ],
        ),
      );
}
