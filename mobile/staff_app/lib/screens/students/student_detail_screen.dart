import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _studentDetailProvider =
    FutureProvider.family<Student, String>((ref, id) async {
  final list = await ref.watch(studentApiProvider).list();
  return list.firstWhere((s) => s.id == id);
});

class StudentDetailScreen extends ConsumerWidget {
  final String studentId;
  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(_studentDetailProvider(studentId));
    return Scaffold(
      appBar: AppBar(title: const Text('Student Details')),
      body: student.when(
        loading: () => const DcLoading(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (s) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              DcAvatar(
                  imageUrl: s.profilePhoto, name: s.name, radius: 48),
              const SizedBox(height: 16),
              Text(s.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DcBadge(label: s.enrollmentStatus.name),
                  const SizedBox(width: 8),
                  DcBadge(label: s.currentStatus.name),
                ],
              ),
              const SizedBox(height: 32),
              _InfoTile(label: 'Roll Number', value: s.rollNumber),
              _InfoTile(label: 'Phone', value: s.phone),
              _InfoTile(label: 'Room', value: s.roomNumber ?? '—'),
              _InfoTile(label: 'Course', value: s.course ?? '—'),
              if (s.email != null) _InfoTile(label: 'Email', value: s.email!),
              const SizedBox(height: 24),
              if (s.enrollmentStatus == EnrollmentStatus.pending)
                Row(
                  children: [
                    Expanded(
                      child: DcButton(
                        label: 'Approve',
                        color: AppColors.success,
                        onPressed: () async {
                          await ref.read(studentApiProvider).approve(s.id);
                          ref.invalidate(_studentDetailProvider(studentId));
                          if (context.mounted) {
                            DcSnackbar.success(context, 'Student approved');
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DcButton(
                        label: 'Reject',
                        color: AppColors.error,
                        outlined: true,
                        onPressed: () async {
                          await ref.read(studentApiProvider).reject(s.id);
                          ref.invalidate(_studentDetailProvider(studentId));
                          if (context.mounted) {
                            DcSnackbar.success(context, 'Student rejected');
                          }
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(label,
                style: const TextStyle(color: AppColors.textSecondary)),
            const Spacer(),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      );
}
