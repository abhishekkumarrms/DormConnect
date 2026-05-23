import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

class GuardLoginScreen extends ConsumerStatefulWidget {
  const GuardLoginScreen({super.key});
  @override
  ConsumerState<GuardLoginScreen> createState() => _GuardLoginScreenState();
}

class _GuardLoginScreenState extends ConsumerState<GuardLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  bool _pinVisible = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref
        .read(authProvider.notifier)
        .guardLogin(_phoneCtrl.text.trim(), _pinCtrl.text.trim());
    if (!ok && mounted) {
      DcSnackbar.error(
          context, ref.read(authProvider).error ?? 'Login failed');
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
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.security,
                        color: AppColors.primary, size: 32),
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
                      Text('Guard Portal',
                          style:
                              TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ]),
                const SizedBox(height: 48),
                const Text('Guard Login',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600)),
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
                const SizedBox(height: 16),
                DcTextField(
                  label: '4-digit PIN',
                  controller: _pinCtrl,
                  keyboardType: TextInputType.number,
                  obscureText: !_pinVisible,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validator: Validators.pin,
                  prefixIcon: const Icon(Icons.pin_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(_pinVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => _pinVisible = !_pinVisible),
                  ),
                ),
                const SizedBox(height: 32),
                DcButton(
                    label: 'Login',
                    onPressed: _login,
                    isLoading: isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
