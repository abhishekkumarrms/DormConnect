import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SosAlertScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  const SosAlertScreen({required this.data, super.key});

  @override
  ConsumerState<SosAlertScreen> createState() => _SosAlertScreenState();
}

class _SosAlertScreenState extends ConsumerState<SosAlertScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final _noteController = TextEditingController();
  bool _responding = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentName = widget.data['student_name'] as String? ?? 'Unknown';
    final room = widget.data['room'] as String? ?? '';
    final sosId = widget.data['sos_id'] as String? ?? '';

    return Scaffold(
      backgroundColor: AppColors.error,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (_, __) => Transform.scale(
                  scale: 1.0 + (_pulseController.value * 0.15),
                  child: const Icon(Icons.emergency,
                      size: 80, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'EMERGENCY SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      studentName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (room.isNotEmpty)
                      Text(
                        'Room $room',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _noteController,
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Describe action taken (optional)',
                  hintStyle:
                      TextStyle(color: Colors.white.withOpacity(0.6)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.white.withOpacity(0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _responding ? null : () => _respond(context, sosId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _responding
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Mark as Responded',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Dismiss',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _respond(BuildContext context, String sosId) async {
    if (sosId.isEmpty) {
      Navigator.pop(context);
      return;
    }
    setState(() => _responding = true);
    try {
      await ref.read(apiClientProvider).post(
        '/api/v1/sos/$sosId/respond',
        data: {'note': _noteController.text.trim()},
      );
    } catch (_) {
      if (mounted) {
        setState(() => _responding = false);
        DcSnackbar.error(context, 'Failed to mark response. Try again.');
      }
      return;
    }
    if (mounted) {
      setState(() => _responding = false);
      Navigator.pop(context);
    }
  }
}
