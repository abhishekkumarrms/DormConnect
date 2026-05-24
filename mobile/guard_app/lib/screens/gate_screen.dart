import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/gate_provider.dart';
import '../widgets/offline_banner.dart';
import '../widgets/request_card.dart';

class GateScreen extends ConsumerWidget {
  const GateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gate = ref.watch(gateProvider);
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(children: [
          // Header bar
          _GateHeader(gate: gate, now: now),

          // Offline banner
          if (!gate.isOnline) OfflineBanner(lastSyncAt: gate.lastSyncAt),

          // Scrollable content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(gateProvider.notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
                children: [
                  // EXIT REQUESTS
                  _SectionHeader(
                    icon: Icons.arrow_circle_up_rounded,
                    label: 'EXIT REQUESTS',
                    count: gate.exitRequests.length,
                    color: const Color(0xFFEF4444),
                  ),
                  if (gate.exitRequests.isEmpty)
                    _EmptySection(label: 'No exit OTPs pending'),
                  ...gate.exitRequests.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: RequestCard(
                        request: r,
                        onTap: () => context.go('/confirm', extra: r),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ENTRY REQUESTS
                  _SectionHeader(
                    icon: Icons.arrow_circle_down_rounded,
                    label: 'ENTRY REQUESTS',
                    count: gate.entryRequests.length,
                    color: const Color(0xFF10B981),
                  ),
                  if (gate.entryRequests.isEmpty)
                    _EmptySection(label: 'No entry OTPs pending'),
                  ...gate.entryRequests.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: RequestCard(
                        request: r,
                        onTap: () => context.go('/confirm', extra: r),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ON LEAVE — approved leave, student still IN, expecting exit today
                  _SectionHeader(
                    icon: Icons.event_available_rounded,
                    label: 'ON LEAVE TODAY',
                    count: gate.onLeaveStudents.length,
                    color: const Color(0xFF2DD4BF),
                  ),
                  if (gate.onLeaveStudents.isEmpty)
                    _EmptySection(label: 'No approved leave departures today'),
                  ...gate.onLeaveStudents.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _OnLeaveCard(
                        student: s,
                        onTap: () => context.go(
                          '/confirm',
                          extra: s.toExitRequest(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // OUT COUNT
                  _SectionHeader(
                    icon: Icons.people_outline_rounded,
                    label: 'OUTSIDE',
                    count: gate.studentsOutCount,
                    color: const Color(0xFF6B7280),
                  ),
                  _EmptySection(
                    label: gate.studentsOutCount == 0
                        ? 'All students inside'
                        : '${gate.studentsOutCount} student${gate.studentsOutCount == 1 ? '' : 's'} currently outside',
                  ),
                ],
              ),
            ),
          ),

          // Bottom action buttons
          _BottomBar(),
        ]),
      ),

      // Visitor FAB
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => _showVisitorSheet(context, ref),
        backgroundColor: const Color(0xFF0F172A),
        child: const Icon(Icons.person_add_outlined,
            color: Colors.white, size: 20),
      ),
    );
  }

  void _showVisitorSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _VisitorSheet(),
    );
  }
}

class _GateHeader extends StatelessWidget {
  final GateState gate;
  final DateTime now;
  const _GateHeader({required this.gate, required this.now});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        const Icon(Icons.security_rounded,
            color: Color(0xFF38BDF8), size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'GATE  ·  ${DateFormat('EEE d MMM').format(now)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Row(children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: gate.isOnline
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            gate.isOnline ? 'Online' : 'Offline',
            style: TextStyle(
                color: gate.isOnline
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 14),
          const Icon(Icons.people_outline_rounded,
              color: Color(0xFF94A3B8), size: 14),
          const SizedBox(width: 4),
          Text(
            'Out: ${gate.studentsOutCount}',
            style: const TextStyle(
                color: Color(0xFF94A3B8), fontSize: 12),
          ),
        ]),
      ]),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Row(children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            '$label ($count)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ]),
      );
}

class _EmptySection extends StatelessWidget {
  final String label;
  const _EmptySection({required this.label});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Color(0xFF94A3B8), fontSize: 14)),
      );
}

class _OnLeaveCard extends StatelessWidget {
  final OnLeaveStudent student;
  final VoidCallback onTap;
  const _OnLeaveCard({required this.student, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: const Border(
                left: BorderSide(color: Color(0xFF2DD4BF), width: 3)),
          ),
          child: Row(children: [
            const Icon(Icons.event_available_rounded,
                color: Color(0xFF2DD4BF), size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.studentName,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Rm ${student.roomNumber}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            const Text(
              'LOG EXIT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2DD4BF),
              ),
            ),
          ]),
        ),
      );
}

class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.go('/manual'),
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Manual Entry',
                  style: TextStyle(fontSize: 15)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Color(0xFF0F172A)),
                foregroundColor: const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.go('/shift-log'),
              icon: const Icon(Icons.history_rounded, size: 16),
              label: const Text('Shift Log',
                  style: TextStyle(fontSize: 15)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Color(0xFF6B7280)),
                foregroundColor: const Color(0xFF6B7280),
              ),
            ),
          ),
        ]),
      );
}

// ── Visitor bottom sheet ─────────────────────────────────────────────────────

class _VisitorSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_VisitorSheet> createState() => _VisitorSheetState();
}

class _VisitorSheetState extends ConsumerState<_VisitorSheet> {
  List<Visitor>? _visitors;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final pending = await ref.read(visitorApiProvider).list(status: 'approved');
      final inside = await ref.read(visitorApiProvider).getActive();
      setState(() {
        _visitors = [...pending, ...inside];
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Visitor Entry / Exit',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          if (_loading) const Center(child: CircularProgressIndicator()),
          if (!_loading && (_visitors == null || _visitors!.isEmpty))
            const Text('No pending visitors',
                style: TextStyle(color: Color(0xFF6B7280))),
          if (_visitors != null)
            ...(_visitors!.map((v) => _VisitorRow(
                  visitor: v,
                  onDone: () {
                    Navigator.pop(context);
                  },
                ))),
        ],
      ),
    );
  }
}

class _VisitorRow extends ConsumerWidget {
  final Visitor visitor;
  final VoidCallback onDone;
  const _VisitorRow({required this.visitor, required this.onDone});

  bool get _isInside => visitor.status == VisitorStatus.inside;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(visitor.visitorName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                if (visitor.relation != null)
                  Text(visitor.relation!,
                      style: const TextStyle(
                          color: Color(0xFF6B7280), fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _tap(context, ref),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isInside
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
            ),
            child: Text(_isInside ? 'Log Exit' : 'Log Entry',
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ]),
      );

  Future<void> _tap(BuildContext context, WidgetRef ref) async {
    try {
      if (_isInside) {
        await ref.read(visitorApiProvider).guardExit(visitor.id);
      } else {
        await ref.read(visitorApiProvider).guardEntry(visitor.id);
      }
      if (context.mounted) {
        DcSnackbar.success(
            context, _isInside ? 'Exit logged' : 'Entry logged');
        onDone();
      }
    } catch (e) {
      if (context.mounted) DcSnackbar.error(context, e.toString());
    }
  }
}
