import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  bool _showReject = false;
  bool _loading = false;

  @override
  void dispose() {
    _rejectReasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _approve(Student student) async {
    setState(() => _loading = true);
    try {
      await ref.read(studentApiProvider).approve(student.id);
      if (mounted) {
        DcSnackbar.success(context, '${student.name} approved');
        context.go('/home/students');
      }
    } catch (e) {
      if (mounted) DcSnackbar.error(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _reject(Student student) async {
    if (_rejectReasonCtrl.text.trim().isEmpty) {
      DcSnackbar.error(context, 'Enter rejection reason');
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(studentApiProvider).reject(student.id,
          reason: _rejectReasonCtrl.text.trim());
      if (mounted) {
        DcSnackbar.success(context, 'Application rejected');
        context.go('/home/students');
      }
    } catch (e) {
      if (mounted) DcSnackbar.error(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentAsync =
        ref.watch(_enrollStudentProvider(widget.studentId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrollment Review'),
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
              // Student info card
              DcCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      DcAvatar(name: student.name, radius: 28),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(student.name,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700)),
                            Text(student.rollNumber,
                                style: const TextStyle(
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      DcStatusChip(
                          status: student.enrollmentStatus.name),
                    ]),
                    const Divider(height: 20),
                    _InfoRow('Phone', student.phone),
                    if (student.email != null)
                      _InfoRow('Email', student.email!),
                    _InfoRow('Room', student.roomNumber ?? '—'),
                    if (student.course != null)
                      _InfoRow('Course', student.course!),
                    if (student.year != null)
                      _InfoRow('Year', 'Year ${student.year}'),
                    if (student.guardianName != null)
                      _InfoRow('Guardian', student.guardianName!),
                    if (student.guardianPhone != null)
                      _InfoRow('Guardian Phone', student.guardianPhone!),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Fee receipt
              if (student.feeReceiptUrl != null) ...[
                const Text('Fee Receipt',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 8),
                GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      student.feeReceiptUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 100,
                        color: AppColors.surfaceVariant,
                        child: const Center(
                            child: Text('Fee receipt uploaded',
                                style: TextStyle(
                                    color: AppColors.textSecondary))),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Reject form
              if (_showReject) ...[
                DcTextField(
                  label: 'Rejection Reason *',
                  controller: _rejectReasonCtrl,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
              ],

              // Action buttons
              if (student.enrollmentStatus == EnrollmentStatus.pending) ...[
                Row(children: [
                  Expanded(
                    child: DcButton(
                      label: _showReject ? 'Confirm Reject' : 'Reject',
                      onPressed: _loading
                          ? null
                          : _showReject
                              ? () => _reject(student)
                              : () => setState(() => _showReject = true),
                      outlined: true,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (!_showReject)
                    Expanded(
                      child: DcButton(
                        label: 'Approve',
                        onPressed:
                            _loading ? null : () => _approve(student),
                        isLoading: _loading,
                        color: AppColors.success,
                      ),
                    ),
                ]),
                if (_showReject) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() {
                      _showReject = false;
                      _rejectReasonCtrl.clear();
                    }),
                    child: const Text('Cancel'),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(children: [
          SizedBox(
            width: 110,
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
