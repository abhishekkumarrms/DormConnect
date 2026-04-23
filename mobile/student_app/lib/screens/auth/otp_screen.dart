import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpCtrl = TextEditingController();
  int _seconds = 300; // 5 min
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds == 0) {
        t.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref
        .read(authProvider.notifier)
        .verifyOtp(widget.phone, _otpCtrl.text.trim());
    if (!ok && mounted) {
      DcSnackbar.error(context, ref.read(authProvider).error ?? 'Invalid OTP');
    }
  }

  Future<void> _resend() async {
    setState(() => _seconds = 300);
    _timer?.cancel();
    _startTimer();
    await ref.read(authProvider.notifier).sendOtp(widget.phone);
    if (mounted) DcSnackbar.success(context, 'OTP resent');
  }

  String get _timerText {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text('OTP sent to +91 ${widget.phone}',
                    style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 32),
                DcTextField(
                  label: '6-digit OTP',
                  controller: _otpCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  validator: Validators.otp,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Expires in $_timerText',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                    if (_seconds == 0)
                      TextButton(
                          onPressed: _resend, child: const Text('Resend OTP')),
                  ],
                ),
                const SizedBox(height: 24),
                DcButton(
                  label: 'Verify',
                  onPressed: _verify,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
