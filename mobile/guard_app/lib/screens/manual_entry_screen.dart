import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/gate_provider.dart';

class ManualEntryScreen extends ConsumerStatefulWidget {
  const ManualEntryScreen({super.key});

  @override
  ConsumerState<ManualEntryScreen> createState() =>
      _ManualEntryScreenState();
}

class _ManualEntryScreenState extends ConsumerState<ManualEntryScreen> {
  final _roomCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _type = 'out';
  bool _loading = false;
  bool _done = false;

  @override
  void dispose() {
    _roomCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_roomCtrl.text.trim().isEmpty) {
      DcSnackbar.error(context, 'Enter room number');
      return;
    }
    setState(() => _loading = true);
    final ok = await ref.read(gateProvider.notifier).manualEntry(
          _roomCtrl.text.trim(),
          _type,
          _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        );
    if (mounted) {
      setState(() {
        _loading = false;
        _done = ok;
      });
      if (ok) {
        DcSnackbar.success(context, 'Manual entry logged');
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) context.go('/gate');
      } else {
        DcSnackbar.error(
            context, ref.read(gateProvider).error ?? 'Failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: const Text('Manual Entry'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/gate'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Room number
              const Text('Room Number',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(
                controller: _roomCtrl,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9A-Za-z]')),
                  LengthLimitingTextInputFormatter(10),
                ],
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  hintText: 'e.g. 204',
                  hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFF0F172A), width: 2)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 18),
                ),
              ),

              const SizedBox(height: 28),

              // Movement type toggle
              const Text('Type',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Row(children: [
                _TypeBtn(
                  label: '↑  EXIT',
                  selected: _type == 'out',
                  color: const Color(0xFFEF4444),
                  onTap: () => setState(() => _type = 'out'),
                ),
                const SizedBox(width: 12),
                _TypeBtn(
                  label: '↓  ENTRY',
                  selected: _type == 'in',
                  color: const Color(0xFF10B981),
                  onTap: () => setState(() => _type = 'in'),
                ),
              ]),

              const SizedBox(height: 28),

              // Note
              const Text('Note (optional)',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(
                controller: _noteCtrl,
                maxLines: 2,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Why manual? (dead battery, no phone…)',
                  hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8), fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),

              const Spacer(),

              // Warning
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF9C3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFFFBBF24).withOpacity(0.5)),
                ),
                child: const Row(children: [
                  Icon(Icons.warning_amber_rounded,
                      size: 16, color: Color(0xFFD97706)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Manual entries are flagged for caretaker review.',
                      style: TextStyle(
                          fontSize: 13, color: Color(0xFF92400E)),
                    ),
                  ),
                ]),
              ),

              const SizedBox(height: 16),

              // Submit
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _loading || _done ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2)
                      : Text(
                          _done ? '✓ Logged!' : 'SUBMIT',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _TypeBtn({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: selected ? color.withOpacity(0.12) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: selected ? color : const Color(0xFFE2E8F0),
                  width: selected ? 2 : 1),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: selected ? color : const Color(0xFF94A3B8),
              ),
            ),
          ),
        ),
      );
}
