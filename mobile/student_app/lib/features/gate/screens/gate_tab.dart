import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/gate_provider.dart';
import '../widgets/going_out_sheet.dart';
import '../widgets/otp_display_widget.dart';

final _studentStatusProvider = FutureProvider<Student>((ref) =>
    ref.watch(studentApiProvider).getProfile());

class GateTab extends ConsumerWidget {
  const GateTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(_studentStatusProvider);
    final gateState = ref.watch(gateNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Gate Pass'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => context.go('/gate/history'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(_studentStatusProvider),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // OTP display if active/expired
            if (gateState.status == OtpStatus.active ||
                gateState.status == OtpStatus.expired)
              OtpDisplayWidget(
                gateState: gateState,
                onCancel: () => ref.read(gateNotifierProvider.notifier).cancelOtp(),
              )
            else ...[
              profileAsync.when(
                loading: () => const DcLoading(),
                error: (e, _) => Center(child: Text(e.toString())),
                data: (student) => _StatusSection(
                  student: student,
                  isLoading: gateState.status == OtpStatus.loading,
                  error: gateState.error,
                  onGoingOut: () => _showGoingOutSheet(context, ref, student),
                  onImBack: () => ref
                      .read(gateNotifierProvider.notifier)
                      .generateOtp(movementType: 'in'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showGoingOutSheet(
      BuildContext context, WidgetRef ref, Student student) {
    DcBottomSheet.show<void>(
      context,
      title: 'Going Out',
      child: GoingOutSheet(
        onGenerate: (destination, expectedReturn) {
          Navigator.pop(context);
          ref.read(gateNotifierProvider.notifier).generateOtp(
                movementType: 'out',
                destination: destination,
                expectedReturn: expectedReturn,
              );
        },
      ),
    );
  }
}

class _StatusSection extends StatelessWidget {
  final Student student;
  final bool isLoading;
  final String? error;
  final VoidCallback onGoingOut;
  final VoidCallback onImBack;

  const _StatusSection({
    required this.student,
    required this.isLoading,
    required this.error,
    required this.onGoingOut,
    required this.onImBack,
  });

  @override
  Widget build(BuildContext context) {
    final isIn = student.currentStatus == StudentStatus.inHostel;
    final statusColor = isIn ? AppColors.success : AppColors.warning;

    return Column(
      children: [
        DcCard(
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isIn
                      ? Icons.home_rounded
                      : Icons.directions_walk_rounded,
                  color: statusColor,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isIn ? 'You are IN the hostel' : 'You are OUT of the hostel',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isIn
                    ? 'Generate an OTP to exit through the gate'
                    : 'Generate an OTP to re-enter the hostel',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),
              if (error != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(error!,
                      style: const TextStyle(
                          color: AppColors.error, fontSize: 13)),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: isLoading
                      ? null
                      : isIn
                          ? onGoingOut
                          : onImBack,
                  icon: Icon(
                    isIn ? Icons.logout_rounded : Icons.login_rounded,
                    size: 20,
                  ),
                  label: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Text(
                          isIn ? 'Generate Going-Out OTP' : "I'm Back",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                  style: FilledButton.styleFrom(
                    backgroundColor: isIn ? AppColors.primary : AppColors.success,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
