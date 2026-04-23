import 'package:cached_network_image/cached_network_image.dart';
import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/child_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(childProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'DormConnect',
          style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              fontSize: 20),
        ),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Color(0xFF0F172A)),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Color(0xFF0F172A)),
            onPressed: () => context.push('/notices'),
          ),
        ],
      ),
      drawer: _GuardianDrawer(userName: user?.name ?? 'Guardian'),
      body: RefreshIndicator(
        onRefresh: () => ref.read(childProvider.notifier).refresh(),
        child: child.isLoading && child.student == null
            ? const _LoadingBody()
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (child.error != null && child.student == null)
                      _ErrorBanner(error: child.error!),

                    // Status card
                    _StatusCard(state: child),

                    const SizedBox(height: 20),

                    // Quick actions
                    _QuickActions(),

                    const SizedBox(height: 24),

                    // Today's activity
                    _SectionHeader(
                      title: 'Recent Activity',
                      onMore: () => context.push('/movements'),
                    ),
                    const SizedBox(height: 10),
                    if (child.recentMovements.isEmpty)
                      _EmptySection(
                        icon: Icons.directions_walk_outlined,
                        label: 'No recent movement',
                      )
                    else
                      ...child.recentMovements
                          .take(3)
                          .map((m) => _MovementTile(log: m)),

                    const SizedBox(height: 24),

                    // Leave status
                    _SectionHeader(
                      title: 'Leave Applications',
                      onMore: () => context.push('/leaves'),
                    ),
                    const SizedBox(height: 10),
                    if (child.activeLeaves.isEmpty)
                      _EmptySection(
                        icon: Icons.beach_access_outlined,
                        label: 'No leave applications',
                      )
                    else
                      ...child.activeLeaves
                          .take(3)
                          .map((l) => _LeaveCard(leave: l)),

                    const SizedBox(height: 16),

                    if (child.lastUpdated != null)
                      Center(
                        child: Text(
                          'Updated ${DateFormat('h:mm a').format(child.lastUpdated!)}',
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF9CA3AF)),
                        ),
                      ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
      ),
    );
  }
}

class _GuardianDrawer extends ConsumerWidget {
  final String userName;
  const _GuardianDrawer({required this.userName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(childProvider);
    final student = child.student;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF0F172A),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.family_restroom,
                      color: Colors.white, size: 36),
                  const SizedBox(height: 12),
                  Text(
                    userName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  if (student != null)
                    Text(
                      'Ward: ${student.name}',
                      style: const TextStyle(
                          color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            _DrawerItem(
              icon: Icons.home_outlined,
              label: 'Home',
              onTap: () {
                Navigator.pop(context);
                context.go('/home');
              },
            ),
            _DrawerItem(
              icon: Icons.directions_walk_outlined,
              label: 'Movements',
              onTap: () {
                Navigator.pop(context);
                context.push('/movements');
              },
            ),
            _DrawerItem(
              icon: Icons.beach_access_outlined,
              label: 'Leave Applications',
              onTap: () {
                Navigator.pop(context);
                context.push('/leaves');
              },
            ),
            _DrawerItem(
              icon: Icons.campaign_outlined,
              label: 'Notices',
              onTap: () {
                Navigator.pop(context);
                context.push('/notices');
              },
            ),
            _DrawerItem(
              icon: Icons.contact_phone_outlined,
              label: 'Contact Hostel',
              onTap: () {
                Navigator.pop(context);
                context.push('/contact');
              },
            ),

            const Spacer(),
            const Divider(),

            _DrawerItem(
              icon: Icons.logout_rounded,
              label: 'Logout',
              color: const Color(0xFFEF4444),
              onTap: () {
                Navigator.pop(context);
                ref.read(authProvider.notifier).logout();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: color ?? const Color(0xFF334155), size: 22),
        title: Text(label,
            style: TextStyle(
                color: color ?? const Color(0xFF334155),
                fontWeight: FontWeight.w500)),
        onTap: onTap,
        dense: true,
      );
}

class _StatusCard extends StatelessWidget {
  final ChildState state;
  const _StatusCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final student = state.student;
    final isIn = state.isInHostel;
    final bgColor = isIn ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7);
    final textColor =
        isIn ? const Color(0xFF166534) : const Color(0xFF92400E);
    final icon =
        isIn ? Icons.home_rounded : Icons.directions_walk_rounded;
    final statusText = isIn ? 'IN HOSTEL' : 'OUT OF HOSTEL';
    final subText = isIn
        ? 'Your ward is safely inside the hostel'
        : 'Your ward has left the hostel';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isIn
                ? const Color(0xFF86EFAC)
                : const Color(0xFFFCD34D)),
      ),
      child: Row(children: [
        // Photo / avatar
        _ChildAvatar(student: student, size: 56),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                student?.name ?? '—',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A)),
              ),
              if (student?.roomNumber != null)
                Text(
                  'Room ${student!.roomNumber}  •  ${student.hostelName ?? ''}',
                  style: TextStyle(
                      fontSize: 12, color: textColor.withOpacity(0.8)),
                ),
              const SizedBox(height: 8),
              Row(children: [
                Icon(icon, size: 16, color: textColor),
                const SizedBox(width: 4),
                Text(
                  statusText,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: textColor),
                ),
              ]),
              Text(subText,
                  style:
                      TextStyle(fontSize: 11, color: textColor.withOpacity(0.8))),
            ],
          ),
        ),
      ]),
    );
  }
}

class _ChildAvatar extends StatelessWidget {
  final Student? student;
  final double size;
  const _ChildAvatar({this.student, required this.size});

  @override
  Widget build(BuildContext context) {
    final photo = student?.profilePhoto;
    if (photo != null && photo.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: photo,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) =>
              _Initials(name: student?.name ?? '?', size: size),
        ),
      );
    }
    return _Initials(name: student?.name ?? '?', size: size);
  }
}

class _Initials extends StatelessWidget {
  final String name;
  final double size;
  const _Initials({required this.name, required this.size});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().split(' ').take(2).map((w) => w[0]).join();
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF1E293B),
      ),
      alignment: Alignment.center,
      child: Text(
        initials.toUpperCase(),
        style: TextStyle(
          fontSize: size * 0.38,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF38BDF8),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: _ActionBtn(
          icon: Icons.directions_walk_outlined,
          label: 'Movements',
          color: const Color(0xFF3B82F6),
          onTap: () => context.push('/movements'),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _ActionBtn(
          icon: Icons.beach_access_outlined,
          label: 'Leaves',
          color: const Color(0xFF8B5CF6),
          onTap: () => context.push('/leaves'),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _ActionBtn(
          icon: Icons.contact_phone_outlined,
          label: 'Contact',
          color: const Color(0xFF10B981),
          onTap: () => context.push('/contact'),
        ),
      ),
    ]);
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onMore;
  const _SectionHeader({required this.title, required this.onMore});

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A))),
        ),
        GestureDetector(
          onTap: onMore,
          child: const Text('See all',
              style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF3B82F6),
                  fontWeight: FontWeight.w600)),
        ),
      ]);
}

class _MovementTile extends StatelessWidget {
  final MovementLog log;
  const _MovementTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final isOut = log.type == MovementType.out;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isOut
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF10B981))
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isOut ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            color: isOut
                ? const Color(0xFFEF4444)
                : const Color(0xFF10B981),
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            isOut ? 'Left hostel' : 'Returned to hostel',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        Text(
          log.createdAt != null
              ? DateFormat('h:mm a').format(log.createdAt!)
              : '',
          style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
        ),
      ]),
    );
  }
}

class _LeaveCard extends StatelessWidget {
  final LeaveApplication leave;
  const _LeaveCard({required this.leave});

  Color get _statusColor {
    switch (leave.status) {
      case LeaveStatus.approved:
        return const Color(0xFF10B981);
      case LeaveStatus.rejected:
        return const Color(0xFFEF4444);
      case LeaveStatus.guardianContacted:
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.push('/leaves/${leave.id}'),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${DateFormat('d MMM').format(leave.fromDate)} → ${DateFormat('d MMM').format(leave.toDate)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    leave.reason,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _statusColor.withOpacity(0.3)),
              ),
              child: Text(
                leave.status.name,
                style: TextStyle(
                    fontSize: 11,
                    color: _statusColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ]),
        ),
      );
}

class _EmptySection extends StatelessWidget {
  final IconData icon;
  final String label;
  const _EmptySection({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFFCBD5E1)),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF94A3B8), fontSize: 13)),
          ],
        ),
      );
}

class _ErrorBanner extends StatelessWidget {
  final String error;
  const _ErrorBanner({required this.error});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          const Icon(Icons.error_outline,
              color: Color(0xFFEF4444), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(error,
                style: const TextStyle(
                    color: Color(0xFFEF4444), fontSize: 12)),
          ),
        ]),
      );
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DcShimmerList(count: 4),
          ],
        ),
      );
}
