import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

class GuardianLoginScreen extends ConsumerStatefulWidget {
  const GuardianLoginScreen({super.key});
  @override
  ConsumerState<GuardianLoginScreen> createState() =>
      _GuardianLoginScreenState();
}

class _GuardianLoginScreenState
    extends ConsumerState<GuardianLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref
        .read(authProvider.notifier)
        .sendOtp(_phoneCtrl.text.trim());
    if (ok && mounted) {
      context.push('/otp', extra: _phoneCtrl.text.trim());
    } else if (mounted) {
      DcSnackbar.error(
          context, ref.read(authProvider).error ?? 'Failed to send OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.family_restroom,
                        color: AppColors.success, size: 32),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DormConnect',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                      Text('Parent/Guardian Portal',
                          style:
                              TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ]),
                const SizedBox(height: 48),
                const Text('Enter your phone number',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text(
                    'We\'ll send an OTP to verify your identity',
                    style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                DcTextField(
                  label: 'Phone Number',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: Validators.phone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                const SizedBox(height: 32),
                DcButton(
                    label: 'Send OTP',
                    onPressed: _sendOtp,
                    isLoading: isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GuardianOtpScreen extends ConsumerStatefulWidget {
  final String phone;
  const GuardianOtpScreen({super.key, required this.phone});
  @override
  ConsumerState<GuardianOtpScreen> createState() =>
      _GuardianOtpScreenState();
}

class _GuardianOtpScreenState extends ConsumerState<GuardianOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpCtrl = TextEditingController();
  int _seconds = 300;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (t) => _seconds > 0
            ? setState(() => _seconds--)
            : t.cancel());
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
      DcSnackbar.error(
          context, ref.read(authProvider).error ?? 'Invalid OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;
    final m = _seconds ~/ 60, s = _seconds % 60;
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              ),
              const SizedBox(height: 8),
              Text(
                  'Expires in ${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              DcButton(
                  label: 'Verify',
                  onPressed: _verify,
                  isLoading: isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
