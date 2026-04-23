import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

const _navy = Color(0xFF0F172A);
const _navyLight = Color(0xFF1E293B);
const _accent = Color(0xFF38BDF8); // sky-400

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneCtrl = TextEditingController();
  final List<String> _pin = [];
  bool _loading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _pinAppend(String digit) {
    if (_pin.length >= 4) return;
    setState(() => _pin.add(digit));
    if (_pin.length == 4) _tryLogin();
  }

  void _pinDelete() {
    if (_pin.isEmpty) return;
    setState(() => _pin.removeLast());
  }

  Future<void> _tryLogin() async {
    if (_phoneCtrl.text.trim().length < 10) {
      DcSnackbar.error(context, 'Enter valid phone number');
      setState(() => _pin.clear());
      return;
    }
    setState(() => _loading = true);
    final ok = await ref
        .read(authProvider.notifier)
        .guardLogin(_phoneCtrl.text.trim(), _pin.join());
    if (mounted) {
      setState(() => _loading = false);
      if (!ok) {
        DcSnackbar.error(
            context, ref.read(authProvider).error ?? 'Login failed');
        setState(() => _pin.clear());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 48),

              // Logo / title
              const Icon(Icons.security_rounded,
                  color: _accent, size: 56),
              const SizedBox(height: 16),
              const Text(
                'DormConnect',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const Text(
                'GUARD',
                style: TextStyle(
                  color: _accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4,
                ),
              ),

              const SizedBox(height: 48),

              // Phone field
              _NavyField(
                controller: _phoneCtrl,
                hint: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),

              const SizedBox(height: 24),

              // PIN dots
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PIN',
                  style: TextStyle(
                      color: Color(0xFF94A3B8), fontSize: 14),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < _pin.length
                          ? _accent
                          : _navyLight,
                      border: Border.all(
                          color: i < _pin.length
                              ? _accent
                              : const Color(0xFF475569),
                          width: 2),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Custom number pad
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: _accent))
                    : _NumPad(
                        onDigit: _pinAppend,
                        onDelete: _pinDelete,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavyField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _NavyField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF64748B)),
          prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
          filled: true,
          fillColor: _navyLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: _accent, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 18),
        ),
      );
}

class _NumPad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;

  const _NumPad({required this.onDigit, required this.onDelete});

  static const _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', '⌫'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _rows.map((row) {
        return Expanded(
          child: Row(
            children: row.map((key) {
              if (key.isEmpty) {
                return const Expanded(child: SizedBox());
              }
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: _PadKey(
                    label: key,
                    onTap: () {
                      if (key == '⌫') {
                        onDelete();
                      } else {
                        onDigit(key);
                      }
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _PadKey extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PadKey({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        color: _navyLight,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: _accent.withOpacity(0.2),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: label == '⌫'
                    ? const Color(0xFF94A3B8)
                    : Colors.white,
                fontSize: label == '⌫' ? 22 : 26,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
}
