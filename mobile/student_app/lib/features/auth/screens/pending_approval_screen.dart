import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingApprovalScreen extends ConsumerStatefulWidget {
  const PendingApprovalScreen({super.key});

  @override
  ConsumerState<PendingApprovalScreen> createState() => _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends ConsumerState<PendingApprovalScreen> {
  bool _checking = false;

  Future<void> _checkStatus() async {
    setState(() => _checking = true);
    try {
      final student = await ref.read(studentApiProvider).getProfile();
      if (!mounted) return;
      if (student.enrollmentStatus == EnrollmentStatus.active) {
        ref.invalidate(authProvider);
      } else {
        DcSnackbar.show(context, 'Not approved yet. Please visit the caretaker office.');
      }
    } catch (_) {
      if (mounted) DcSnackbar.error(context, 'Could not check status. Try again.');
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.how_to_reg_outlined,
                      size: 48, color: AppColors.success),
                ),
                const SizedBox(height: 24),
                const Text('Registration Submitted!',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary)),
                const SizedBox(height: 8),
                const Text('One last step to activate your account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                const SizedBox(height: 32),

                // Step guide
                _StepRow(
                  number: '1',
                  text: 'Registration submitted',
                  done: true,
                ),
                const SizedBox(height: 12),
                _StepRow(
                  number: '2',
                  text: 'Visit caretaker / warden office in person',
                  active: true,
                ),
                const SizedBox(height: 12),
                _StepRow(
                  number: '3',
                  text: 'Identity verified → Account activated',
                ),
                const SizedBox(height: 28),

                // Info box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF59E0B)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          color: Color(0xFFD97706), size: 18),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Bring your college ID card to the caretaker or warden office. '
                          'This is a one-time in-person check. Office hours: 9 AM – 5 PM.',
                          style: TextStyle(
                              color: Color(0xFF92400E),
                              fontSize: 13,
                              height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _checking ? null : _checkStatus,
                    icon: _checking
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.refresh_rounded),
                    label: const Text('Check Approval Status'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => ref.read(authProvider.notifier).logout(),
                  child: const Text('Logout',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Made with ❤️ by Cosmolith',
                  style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      );
}

class _StepRow extends StatelessWidget {
  final String number;
  final String text;
  final bool done;
  final bool active;

  const _StepRow({
    required this.number,
    required this.text,
    this.done = false,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = done
        ? AppColors.success
        : active
            ? AppColors.primary
            : AppColors.textTertiary;
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.12),
          ),
          alignment: Alignment.center,
          child: done
              ? Icon(Icons.check_rounded, color: color, size: 16)
              : Text(number,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text,
              style: TextStyle(
                  color: color,
                  fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14)),
        ),
      ],
    );
  }
}
