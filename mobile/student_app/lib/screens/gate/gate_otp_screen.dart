import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _gateOtpProvider = StateProvider<GateOtp?>((ref) => null);
final _secondsProvider = StateProvider<int>((ref) => 0);

class GateOtpScreen extends ConsumerStatefulWidget {
  const GateOtpScreen({super.key});
  @override
  ConsumerState<GateOtpScreen> createState() => _GateOtpScreenState();
}

class _GateOtpScreenState extends ConsumerState<GateOtpScreen> {
  Timer? _timer;
  bool _loading = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _generateOtp() async {
    setState(() => _loading = true);
    try {
      final otp = await ref.read(gateApiProvider).generateOtp();
      ref.read(_gateOtpProvider.notifier).state = otp;
      ref.read(_secondsProvider.notifier).state = otp.expiresInSeconds;
      _startTimer();
    } catch (e) {
      if (mounted) DcSnackbar.error(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final s = ref.read(_secondsProvider);
      if (s <= 0) {
        _timer?.cancel();
        ref.read(_gateOtpProvider.notifier).state = null;
      } else {
        ref.read(_secondsProvider.notifier).state = s - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final otp = ref.watch(_gateOtpProvider);
    final seconds = ref.watch(_secondsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gate OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            const Text('Show this OTP to the guard at the gate',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 48),
            if (otp != null) ...[
              _OtpDisplay(otp: otp.otp, seconds: seconds),
              const SizedBox(height: 32),
              LinearProgressIndicator(
                value: seconds / otp.expiresInSeconds,
                color: seconds < 30 ? AppColors.error : AppColors.primary,
                backgroundColor: AppColors.surfaceVariant,
              ),
              const SizedBox(height: 16),
              Text('Expires in ${seconds}s',
                  style: TextStyle(
                      color: seconds < 30
                          ? AppColors.error
                          : AppColors.textSecondary)),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: _generateOtp,
                icon: const Icon(Icons.refresh),
                label: const Text('Regenerate'),
              ),
            ] else ...[
              const Icon(Icons.door_front_door_outlined,
                  size: 80, color: AppColors.textTertiary),
              const SizedBox(height: 32),
              DcButton(
                label: 'Generate Gate OTP',
                onPressed: _generateOtp,
                isLoading: _loading,
                icon: Icons.qr_code,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OtpDisplay extends StatelessWidget {
  final String otp;
  final int seconds;
  const _OtpDisplay({required this.otp, required this.seconds});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: seconds < 30 ? AppColors.error : AppColors.primary,
            width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: otp.split('').map((c) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(c,
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: seconds < 30 ? AppColors.error : AppColors.primary,
                  fontFamily: 'monospace')),
        )).toList(),
      ),
    );
  }
}
