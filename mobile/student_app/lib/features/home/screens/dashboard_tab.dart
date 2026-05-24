import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final _profileProvider = FutureProvider<Student>((ref) async =>
    ref.watch(studentApiProvider).getProfile());

final _recentMovementsProvider =
    FutureProvider<List<MovementLog>>((ref) async =>
        ref.watch(gateApiProvider).getHistory(limit: 1));

final _myComplaintsProvider = FutureProvider<List<Complaint>>((ref) async =>
    ref.watch(complaintApiProvider).list(limit: 2));

final _messMenuTodayProvider = FutureProvider<List<MessMenu>>((ref) async {
  final profile = await ref.watch(_profileProvider.future);
  return ref.watch(messApiProvider).getMenu(profile.hostelId);
});

final _latestBroadcastProvider =
    FutureProvider<List<Broadcast>>((ref) async =>
        ref.watch(broadcastApiProvider).list(limit: 1));

final _myLeavesProvider = FutureProvider<List<LeaveApplication>>((ref) async =>
    ref.watch(leaveApiProvider).list(status: 'approved', limit: 3));

class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(_profileProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('DormConnect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.go('/broadcasts'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(_profileProvider);
          ref.invalidate(_recentMovementsProvider);
          ref.invalidate(_myComplaintsProvider);
          ref.invalidate(_messMenuTodayProvider);
          ref.invalidate(_latestBroadcastProvider);
          ref.invalidate(_myLeavesProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Status card
            profileAsync.when(
              loading: () => const _SkeletonCard(height: 110),
              error: (e, _) => _ErrorCard(message: e.toString()),
              data: (student) => _StatusCard(
                greeting: _greeting(),
                student: student,
                recentMovement: ref.watch(_recentMovementsProvider),
              ),
            ),
            const SizedBox(height: 16),

            // Active leave banner
            ref.watch(_myLeavesProvider).whenData((leaves) {
              final now = DateTime.now();
              final active = leaves.where((l) =>
                  l.fromDate.isBefore(now) && l.toDate.isAfter(now)).toList();
              if (active.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    const Text('🏖️', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'On Leave · Returns ${active.first.toDate.formatted}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.info),
                      ),
                    ),
                  ]),
                ),
              );
            }).value ??
                const SizedBox.shrink(),

            // Quick actions
            const _QuickActionsRow(),
            const SizedBox(height: 20),

            // Recent complaints
            _SectionHeader(
              title: 'Recent Issues',
              onMore: () => context.go('/home/activity'),
            ),
            ref.watch(_myComplaintsProvider).when(
              loading: () => const _SkeletonCard(height: 80),
              error: (_, __) => const SizedBox.shrink(),
              data: (list) => list.isEmpty
                  ? const _EmptyRow(message: 'No complaints filed')
                  : Column(
                      children: list
                          .map((c) => _ComplaintRow(complaint: c))
                          .toList()),
            ),
            const SizedBox(height: 20),

            // Today's mess
            _SectionHeader(
              title: "Today's Mess",
              onMore: () => context.go('/mess'),
            ),
            ref.watch(_messMenuTodayProvider).when(
              loading: () => const _SkeletonCard(height: 80),
              error: (_, __) => const _EmptyRow(message: 'Menu not available'),
              data: (menus) {
                final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                final todayMenu =
                    menus.where((m) => m.date == today).toList();
                if (todayMenu.isEmpty) {
                  return const _EmptyRow(message: 'No menu for today');
                }
                final m = todayMenu.first;
                return DcCard(
                  child: Column(
                    children: [
                      if (m.breakfast != null)
                        _MessRow(label: 'B', item: m.breakfast!),
                      if (m.lunch != null)
                        _MessRow(label: 'L', item: m.lunch!),
                      if (m.dinner != null)
                        _MessRow(label: 'D', item: m.dinner!),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Latest broadcast
            _SectionHeader(
              title: 'Latest Announcement',
              onMore: () => context.go('/broadcasts'),
            ),
            ref.watch(_latestBroadcastProvider).when(
              loading: () => const _SkeletonCard(height: 60),
              error: (_, __) => const SizedBox.shrink(),
              data: (list) => list.isEmpty
                  ? const _EmptyRow(message: 'No announcements')
                  : _BroadcastRow(broadcast: list.first),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String greeting;
  final Student student;
  final AsyncValue<List<MovementLog>> recentMovement;

  const _StatusCard({
    required this.greeting,
    required this.student,
    required this.recentMovement,
  });

  @override
  Widget build(BuildContext context) {
    final isIn = student.currentStatus == StudentStatus.inHostel;
    final statusColor = isIn ? AppColors.success : AppColors.warning;
    final lastActivity = recentMovement.whenData((list) =>
        list.isNotEmpty ? list.first : null).value;

    return DcCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$greeting, ${student.name.split(' ').first} 👋',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            '${student.hostelName ?? 'Hostel'} · Room ${student.roomNumber ?? '—'}',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Row(children: [
                Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: statusColor)),
                const SizedBox(width: 6),
                Text(
                  isIn ? 'IN HOSTEL' : 'OUT OF HOSTEL',
                  style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12),
                ),
              ]),
            ),
          ]),
          if (lastActivity != null) ...[
            const SizedBox(height: 6),
            Text(
              lastActivity.type == MovementType.out
                  ? 'Left at ${lastActivity.createdAt?.timeOnly ?? ''}'
                  : 'Returned at ${lastActivity.createdAt?.timeOnly ?? ''}',
              style: const TextStyle(
                  color: AppColors.textTertiary, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          _QuickAction(
            icon: Icons.door_front_door_rounded,
            label: 'Gate',
            color: AppColors.primary,
            onTap: () => context.go('/home/gate'),
          ),
          _QuickAction(
            icon: Icons.beach_access_rounded,
            label: 'Leave',
            color: AppColors.info,
            onTap: () => context.go('/leave'),
          ),
          _QuickAction(
            icon: Icons.report_problem_rounded,
            label: 'Issue',
            color: AppColors.warning,
            onTap: () => context.go('/home/activity'),
          ),
          _QuickAction(
            icon: Icons.restaurant_menu_rounded,
            label: 'Mess',
            color: AppColors.success,
            onTap: () => context.go('/mess'),
          ),
        ],
      );
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Column(children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
      );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onMore;
  const _SectionHeader({required this.title, required this.onMore});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.textPrimary)),
          const Spacer(),
          GestureDetector(
            onTap: onMore,
            child: const Text('See all',
                style:
                    TextStyle(color: AppColors.primary, fontSize: 12)),
          ),
        ]),
      );
}

class _ComplaintRow extends StatelessWidget {
  final Complaint complaint;
  const _ComplaintRow({required this.complaint});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: DcCard(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Expanded(
              child: Text(
                complaint.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            DcStatusChip(status: complaint.status.name),
          ]),
        ),
      );
}

class _MessRow extends StatelessWidget {
  final String label;
  final String item;
  const _MessRow({required this.label, required this.item});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondaryDark)),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Text(item,
                  style: const TextStyle(fontSize: 13),
                  overflow: TextOverflow.ellipsis)),
        ]),
      );
}

class _BroadcastRow extends StatelessWidget {
  final Broadcast broadcast;
  const _BroadcastRow({required this.broadcast});

  @override
  Widget build(BuildContext context) => DcCard(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: broadcast.category == BroadcastCategory.important
                  ? AppColors.error
                  : AppColors.secondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(broadcast.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                if (broadcast.sentByName != null)
                  Text(broadcast.sentByName!,
                      style: const TextStyle(
                          color: AppColors.textTertiary, fontSize: 11)),
              ],
            ),
          ),
        ]),
      );
}

class _EmptyRow extends StatelessWidget {
  final String message;
  const _EmptyRow({required this.message});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(message,
            style: const TextStyle(
                color: AppColors.textTertiary, fontSize: 13)),
      );
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message,
            style: const TextStyle(color: AppColors.error, fontSize: 13)),
      );
}

class _SkeletonCard extends StatelessWidget {
  final double height;
  const _SkeletonCard({required this.height});

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
      );
}
