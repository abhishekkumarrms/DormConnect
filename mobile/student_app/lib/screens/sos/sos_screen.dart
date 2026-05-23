import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});
  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen> {
  bool _triggered = false;
  bool _loading = false;

  Future<void> _trigger() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Trigger SOS Alert?'),
        content: const Text(
            'This will immediately notify all hostel staff. Only use in an emergency.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('TRIGGER SOS'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _loading = true);
    try {
      await ref.read(sosApiProvider).trigger(message: 'Emergency!');
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
      appBar: AppBar(title: const Text('SOS Emergency')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_triggered) ...[
                const Icon(Icons.check_circle, color: AppColors.success, size: 80),
                const SizedBox(height: 24),
                const Text('SOS Triggered!',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success)),
                const SizedBox(height: 12),
                const Text(
                    'Staff have been notified. Help is on the way.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 32),
                OutlinedButton(
                    onPressed: () => setState(() => _triggered = false),
                    child: const Text('Reset')),
              ] else ...[
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.error, width: 3),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _loading ? null : _trigger,
                      borderRadius: BorderRadius.circular(90),
                      child: _loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.error))
                          : const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.sos,
                                      color: AppColors.error, size: 56),
                                  SizedBox(height: 8),
                                  Text('EMERGENCY',
                                      style: TextStyle(
                                          color: AppColors.error,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14)),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                    'Press only in case of a real emergency.\nThis will notify all hostel staff.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
