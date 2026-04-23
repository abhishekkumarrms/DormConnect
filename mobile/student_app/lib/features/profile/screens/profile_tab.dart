import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _profileProvider = FutureProvider<Student>((ref) async =>
    ref.watch(studentApiProvider).getProfile());

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(_profileProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_profileProvider),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const DcLoading(),
        error: (e, _) => DcErrorState(
            message: e.toString(),
            onRetry: () => ref.invalidate(_profileProvider)),
        data: (student) => SingleChildScrollView(
          child: Column(
            children: [
              // Hero section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                color: AppColors.primary,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Text(
                        student.name.isNotEmpty
                            ? student.name[0].toUpperCase()
                            : 'S',
                        style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      student.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student.rollNumber,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        student.enrollmentStatus.name.snakeToTitle,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              // Details section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DcCard(
                      child: Column(
                        children: [
                          _ProfileRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: student.email ?? '—',
                          ),
                          const Divider(height: 16),
                          _ProfileRow(
                            icon: Icons.phone_outlined,
                            label: 'Phone',
                            value: student.phone,
                          ),
                          const Divider(height: 16),
                          _ProfileRow(
                            icon: Icons.hotel_outlined,
                            label: 'Hostel',
                            value: student.hostelName ?? '—',
                          ),
                          const Divider(height: 16),
                          _ProfileRow(
                            icon: Icons.meeting_room_outlined,
                            label: 'Room',
                            value: student.roomNumber ?? '—',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Guardian info
                    if (student.guardianName != null)
                      DcCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Guardian',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: AppColors.textSecondary)),
                            const SizedBox(height: 10),
                            _ProfileRow(
                              icon: Icons.person_outlined,
                              label: 'Name',
                              value: student.guardianName!,
                            ),
                            if (student.guardianPhone != null) ...[
                              const Divider(height: 16),
                              _ProfileRow(
                                icon: Icons.phone_outlined,
                                label: 'Phone',
                                value: student.guardianPhone!,
                              ),
                            ],
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Actions
                    _ActionTile(
                      icon: Icons.beach_access_outlined,
                      label: 'My Leaves',
                      color: AppColors.primary,
                      onTap: () => context.go('/leave'),
                    ),
                    const SizedBox(height: 8),
                    _ActionTile(
                      icon: Icons.report_outlined,
                      label: 'My Complaints',
                      color: AppColors.error,
                      onTap: () => context.go('/home/activity'),
                    ),
                    const SizedBox(height: 8),
                    _ActionTile(
                      icon: Icons.history_rounded,
                      label: 'Movement History',
                      color: AppColors.textSecondary,
                      onTap: () => context.go('/gate/history'),
                    ),
                    const SizedBox(height: 24),

                    // Logout
                    DcButton(
                      label: 'Logout',
                      onPressed: () async {
                        await ref.read(authApiProvider).logout();
                        if (context.mounted) {
                          context.go('/auth/phone');
                        }
                      },
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ProfileRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13)),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
      ]);
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: DcCard(
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textTertiary),
          ]),
        ),
      );
}
