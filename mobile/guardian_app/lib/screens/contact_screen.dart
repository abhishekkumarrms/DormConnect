import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/child_provider.dart';

final _staffContactsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final child = ref.read(childProvider);
  final hostelId = child.student?.hostelId ?? '';
  if (hostelId.isEmpty) return [];
  try {
    final resp = await ref.read(apiClientProvider).get(
      '/api/v1/staff',
      params: {'hostel_id': hostelId, 'limit': 20},
    );
    final data = resp.data as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  } catch (_) {
    return [];
  }
});

class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(childProvider);
    final staff = ref.watch(_staffContactsProvider);
    final student = child.student;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Contact Hostel',
            style: TextStyle(
                color: Color(0xFF0F172A), fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hostel info banner
          if (student != null)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(children: [
                const Icon(Icons.home_work_outlined,
                    color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.hostelName ?? 'Hostel',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Room ${student.roomNumber ?? '—'}',
                        style: const TextStyle(
                            color: Color(0xFF94A3B8), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ]),
            ),

          // Emergency contact
          const _SectionLabel(
              label: '🚨 Emergency',
              color: Color(0xFFEF4444)),
          const SizedBox(height: 8),
          _ContactCard(
            name: 'Hostel Emergency',
            role: 'Available 24/7',
            phone: '100',
            isEmergency: true,
          ),
          const SizedBox(height: 20),

          // Staff contacts
          const _SectionLabel(label: 'Hostel Staff'),
          const SizedBox(height: 8),
          staff.when(
            loading: () => const DcShimmerList(count: 4),
            error: (_, __) => const _FallbackContacts(),
            data: (list) => list.isEmpty
                ? const _FallbackContacts()
                : Column(
                    children: list
                        .map((s) => _StaffContactCard(data: s))
                        .toList(),
                  ),
          ),

          const SizedBox(height: 20),

          // Help text
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: const Row(children: [
              Icon(Icons.info_outline,
                  color: Color(0xFF3B82F6), size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'For leave approvals, please confirm via the Leave Applications section. For urgent matters, call the warden directly.',
                  style:
                      TextStyle(fontSize: 12, color: Color(0xFF1D4ED8)),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color? color;
  const _SectionLabel({required this.label, this.color});

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color ?? const Color(0xFF334155)),
      );
}

class _ContactCard extends StatelessWidget {
  final String name;
  final String role;
  final String phone;
  final bool isEmergency;

  const _ContactCard({
    required this.name,
    required this.role,
    required this.phone,
    this.isEmergency = false,
  });

  Future<void> _call() async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isEmergency
              ? const Color(0xFFFEF2F2)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isEmergency
                  ? const Color(0xFFFCA5A5)
                  : const Color(0xFFE2E8F0)),
        ),
        child: Row(children: [
          DcAvatar(name: name, radius: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                Text(role,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          GestureDetector(
            onTap: _call,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isEmergency
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.phone_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ]),
      );
}

class _StaffContactCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _StaffContactCard({required this.data});

  Future<void> _call(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = (data['name'] as String?) ?? 'Staff';
    final role = (data['role'] as String?) ?? '';
    final phone = (data['phone'] as String?) ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(children: [
        DcAvatar(name: name, radius: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              Text(role,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF6B7280))),
            ],
          ),
        ),
        if (phone.isNotEmpty)
          GestureDetector(
            onTap: () => _call(phone),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.phone_rounded,
                  color: Colors.white, size: 18),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.phone_rounded,
                color: Color(0xFF9CA3AF), size: 18),
          ),
      ]),
    );
  }
}

class _FallbackContacts extends StatelessWidget {
  const _FallbackContacts();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _ContactCard(
            name: 'Warden',
            role: 'Hostel Warden',
            phone: '',
          ),
          _ContactCard(
            name: 'Caretaker',
            role: 'Hostel Caretaker',
            phone: '',
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF9C3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Contact details not available. Please contact the hostel office directly.',
              style: TextStyle(fontSize: 12, color: Color(0xFF92400E)),
            ),
          ),
        ],
      );
}
