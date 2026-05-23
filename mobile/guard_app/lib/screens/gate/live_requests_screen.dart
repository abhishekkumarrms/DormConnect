import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _liveRequestsProvider =
    FutureProvider.autoDispose<List<LiveRequest>>((ref) async {
  return ref.watch(gateApiProvider).getLiveRequests();
});

class LiveRequestsScreen extends ConsumerStatefulWidget {
  const LiveRequestsScreen({super.key});
  @override
  ConsumerState<LiveRequestsScreen> createState() =>
      _LiveRequestsScreenState();
}

class _LiveRequestsScreenState extends ConsumerState<LiveRequestsScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // auto-refresh every 10s
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      ref.invalidate(_liveRequestsProvider);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _confirmOtp(BuildContext context, String otp) async {
    try {
      final result = await ref.read(gateApiProvider).confirmOtp(otp);
      final name = result['student_name'] as String? ?? 'Student';
      final type = result['movement_type'] as String? ?? '';
      if (mounted) {
        DcSnackbar.success(context,
            '$name — ${type == 'GATE_OUT' ? 'Checked OUT' : 'Checked IN'}');
        ref.invalidate(_liveRequestsProvider);
      }
    } catch (e) {
      if (mounted) DcSnackbar.error(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(_liveRequestsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Gate Requests'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_liveRequestsProvider)),
        ],
      ),
      body: requests.when(
        loading: () => const DcShimmerList(count: 3),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) => list.isEmpty
            ? const DcEmptyState(
                icon: Icons.door_front_door_outlined,
                title: 'No pending gate requests',
                subtitle: 'Waiting for students to generate OTPs',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) =>
                    _RequestCard(r: list[i], onConfirm: _confirmOtp),
              ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final LiveRequest r;
  final Future<void> Function(BuildContext, String) onConfirm;
  const _RequestCard({required this.r, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final urgent = r.secondsRemaining < 30;
    return DcCard(
      color: urgent ? AppColors.error.withOpacity(0.05) : null,
      child: Row(
        children: [
          DcAvatar(name: r.studentName, radius: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.studentName,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('Room: ${r.roomNumber ?? '—'} • Roll: ${r.rollNumber ?? '—'}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                Text('${r.secondsRemaining}s remaining',
                    style: TextStyle(
                        fontSize: 12,
                        color: urgent ? AppColors.error : AppColors.textTertiary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(r.otp,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: urgent ? AppColors.error : AppColors.primary,
                      fontFamily: 'monospace')),
              const SizedBox(height: 8),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8)),
                onPressed: () => onConfirm(context, r.otp),
                child: const Text('Confirm', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
