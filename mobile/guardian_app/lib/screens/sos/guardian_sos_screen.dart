import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

final _sosHistoryProvider = FutureProvider<List<SosAlert>>((ref) async {
  return ref.watch(sosApiProvider).getHistory(limit: 20);
});

class GuardianSosScreen extends ConsumerWidget {
  const GuardianSosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(_sosHistoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Alerts'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_sosHistoryProvider)),
        ],
      ),
      body: alerts.when(
        loading: () => const DcShimmerList(count: 3),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) => list.isEmpty
            ? const DcEmptyState(
                icon: Icons.health_and_safety_outlined,
                title: 'No emergency alerts',
                subtitle: 'Your ward has not triggered any SOS alerts',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final a = list[i];
                  final isActive = a.status == SosStatus.triggered;
                  return DcCard(
                    color: isActive
                        ? AppColors.error.withOpacity(0.05)
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(Icons.sos,
                              color: isActive
                                  ? AppColors.error
                                  : AppColors.textTertiary),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(
                            isActive ? 'ACTIVE EMERGENCY' : 'Resolved',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: isActive
                                    ? AppColors.error
                                    : AppColors.success),
                          )),
                          DcBadge(label: a.status.name),
                        ]),
                        const SizedBox(height: 8),
                        if (a.message != null)
                          Text(a.message!,
                              style: const TextStyle(fontSize: 13)),
                        Text(a.createdAt?.formattedWithTime ?? '',
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textTertiary)),
                        if (a.responseNote != null) ...[
                          const Divider(height: 16),
                          Text('Staff response: ${a.responseNote}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.success)),
                        ],
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
