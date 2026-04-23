import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authProvider.notifier).sendOtp(_phoneCtrl.text.trim());
    if (ok && mounted) {
      context.push('/otp', extra: _phoneCtrl.text.trim());
    } else if (mounted) {
      final err = ref.read(authProvider).error ?? 'Failed to send OTP';
      DcSnackbar.error(context, err);
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
                const Text('DormConnect',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
                const SizedBox(height: 8),
                const Text('Student Portal',
                    style: TextStyle(
                        fontSize: 16, color: AppColors.textSecondary)),
                const SizedBox(height: 48),
                const Text('Enter your phone number',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 24),
                DcTextField(
                  label: 'Phone Number',
                  hint: '10-digit mobile number',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: Validators.phone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                const SizedBox(height: 24),
                DcButton(
                  label: 'Send OTP',
                  onPressed: _submit,
                  isLoading: isLoading,
                ),
                const Spacer(),
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/enroll'),
                    child: const Text('New student? Enroll here'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
