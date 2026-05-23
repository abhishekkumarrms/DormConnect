import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  bool _loading = false;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _triggerSos() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Trigger SOS?',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
          'This will immediately alert the warden and caretaker. Only use in a genuine emergency.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white),
            child: const Text('YES, TRIGGER SOS'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _loading = true);
    try {
      await ref.read(sosApiProvider).trigger();
      if (mounted) setState(() => _triggered = true);
    } catch (e) {
      if (mounted) DcSnackbar.error(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _triggered
          ? AppColors.error.withOpacity(0.04)
          : null,
      appBar: AppBar(
        title: const Text('SOS Emergency'),
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/home/dashboard'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: _triggered ? _TriggeredView() : _SosButton(
            loading: _loading,
            pulseAnim: _pulseAnim,
            onTap: _triggerSos,
          ),
        ),
      ),
    );
  }
}

class _SosButton extends StatelessWidget {
  final bool loading;
  final Animation<double> pulseAnim;
  final VoidCallback onTap;
  const _SosButton(
      {required this.loading,
      required this.pulseAnim,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Emergency Alert',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text(
          'Press the button below to immediately notify\nyour warden and caretaker.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 56),
        AnimatedBuilder(
          animation: pulseAnim,
          builder: (_, child) => Transform.scale(
            scale: loading ? 1.0 : pulseAnim.value,
            child: child,
          ),
          child: GestureDetector(
            onTap: loading ? null : onTap,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withOpacity(0.4),
                    blurRadius: 32,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 3))
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sos_rounded,
                            color: Colors.white, size: 52),
                        SizedBox(height: 8),
                        Text(
                          'SOS',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: 48),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppColors.warning.withOpacity(0.3)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_amber_rounded,
                  size: 16, color: AppColors.warning),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Only use in a real emergency. False alarms may result in disciplinary action.',
                  style: TextStyle(
                      color: AppColors.warning,
                      fontSize: 12,
                      height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TriggeredView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle_rounded,
              color: AppColors.error, size: 64),
        ),
        const SizedBox(height: 24),
        const Text(
          'SOS Alert Sent!',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.error),
        ),
        const SizedBox(height: 12),
        const Text(
          'Your warden and caretaker have been notified.\nHelp is on the way.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.textSecondary, height: 1.6),
        ),
        const SizedBox(height: 40),
        DcButton(
          label: 'Go to Dashboard',
          onPressed: () => context.go('/home/dashboard'),
        ),
      ],
    );
  }
}
