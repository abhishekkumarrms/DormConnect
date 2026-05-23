import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _studentProfileProvider = FutureProvider<Student>((ref) async {
  return ref.watch(studentApiProvider).getProfile();
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(_studentProfileProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: profile.when(
        loading: () => const DcLoading(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (s) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              DcAvatar(
                  imageUrl: s.profilePhoto,
                  name: s.name,
                  radius: 48),
              const SizedBox(height: 16),
              Text(s.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700)),
              Text(s.rollNumber,
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              DcBadge(label: s.currentStatus.name),
              const SizedBox(height: 32),
              _InfoRow(icon: Icons.room, label: 'Room', value: s.roomNumber ?? '—'),
              _InfoRow(icon: Icons.phone, label: 'Phone', value: s.phone),
              if (s.email != null)
                _InfoRow(icon: Icons.email, label: 'Email', value: s.email!),
              if (s.course != null)
                _InfoRow(icon: Icons.school, label: 'Course', value: s.course!),
              _InfoRow(
                  icon: Icons.business,
                  label: 'Enrollment',
                  value: s.enrollmentStatus.name),
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
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
                ),
            const Spacer(),
            Text(value,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      );
}
