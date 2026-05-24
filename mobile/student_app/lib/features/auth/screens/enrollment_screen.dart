import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _hostelsProvider = FutureProvider<List<Hostel>>((ref) async {
  final resp = await ref.watch(apiClientProvider).get('/api/v1/hostels');
  final list = resp.data as List<dynamic>;
  return list.map((e) => Hostel.fromJson(e as Map<String, dynamic>)).toList();
});

class EnrollmentScreen extends ConsumerStatefulWidget {
  final String phone;
  const EnrollmentScreen({super.key, required this.phone});

  @override
  ConsumerState<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends ConsumerState<EnrollmentScreen> {
  final _pageCtrl = PageController();
  int _step = 0;

  // Step 1 — personal
  final _nameCtrl = TextEditingController();
  final _rollCtrl = TextEditingController();
  final _roomCtrl = TextEditingController();
  String? _selectedHostelId;

  // Step 2 — guardian
  final _guardianNameCtrl = TextEditingController();
  final _guardianPhoneCtrl = TextEditingController();
  String _guardianRelation = 'Father';

  bool _loading = false;

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    _rollCtrl.dispose();
    _roomCtrl.dispose();
    _guardianNameCtrl.dispose();
    _guardianPhoneCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_nameCtrl.text.trim().isEmpty ||
        _rollCtrl.text.trim().isEmpty ||
        _roomCtrl.text.trim().isEmpty ||
        _selectedHostelId == null) {
      DcSnackbar.error(context, 'Fill all required fields');
      return;
    }
    _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() => _step++);
  }

  void _back() {
    _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() => _step--);
  }

  Future<void> _submit() async {
    if (_guardianNameCtrl.text.trim().isEmpty ||
        _guardianPhoneCtrl.text.trim().length != 10) {
      DcSnackbar.error(context, 'Enter valid guardian name and 10-digit phone');
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(studentApiProvider).enroll({
        'name': _nameCtrl.text.trim(),
        'phone': widget.phone,
        'roll_number': _rollCtrl.text.trim(),
        'hostel_id': _selectedHostelId!,
        'room_number': _roomCtrl.text.trim(),
        'guardian_name': _guardianNameCtrl.text.trim(),
        'guardian_phone': _guardianPhoneCtrl.text.trim(),
        'guardian_relation': _guardianRelation,
      });
      if (mounted) context.go('/auth/pending');
    } catch (e) {
      if (mounted) DcSnackbar.error(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: _step > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded), onPressed: _back)
            : null,
      ),
      body: Column(
        children: [
          _StepIndicator(currentStep: _step),
          Expanded(
            child: PageView(
              controller: _pageCtrl,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _Step1(
                  phone: widget.phone,
                  nameCtrl: _nameCtrl,
                  rollCtrl: _rollCtrl,
                  roomCtrl: _roomCtrl,
                  selectedHostelId: _selectedHostelId,
                  onHostelSelected: (id) => setState(() => _selectedHostelId = id),
                  onNext: _next,
                  hostelsAsync: ref.watch(_hostelsProvider),
                ),
                _Step2(
                  nameCtrl: _guardianNameCtrl,
                  phoneCtrl: _guardianPhoneCtrl,
                  relation: _guardianRelation,
                  onRelationChanged: (v) => setState(() => _guardianRelation = v),
                  onSubmit: _submit,
                  loading: _loading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          children: List.generate(2, (i) {
            final active = i <= currentStep;
            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active ? AppColors.primary : AppColors.border,
                    ),
                    alignment: Alignment.center,
                    child: Text('${i + 1}',
                        style: TextStyle(
                            color: active ? Colors.white : AppColors.textTertiary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                  if (i < 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i < currentStep ? AppColors.primary : AppColors.border,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      );
}

class _Step1 extends StatelessWidget {
  final String phone;
  final TextEditingController nameCtrl, rollCtrl, roomCtrl;
  final String? selectedHostelId;
  final ValueChanged<String> onHostelSelected;
  final VoidCallback onNext;
  final AsyncValue<List<Hostel>> hostelsAsync;

  const _Step1({
    required this.phone,
    required this.nameCtrl,
    required this.rollCtrl,
    required this.roomCtrl,
    required this.selectedHostelId,
    required this.onHostelSelected,
    required this.onNext,
    required this.hostelsAsync,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal Info',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
            const SizedBox(height: 20),
            // Phone — read-only, pre-filled from OTP
            TextFormField(
              initialValue: phone,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone_outlined),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            DcTextField(
                label: 'Full Name *',
                controller: nameCtrl),
            const SizedBox(height: 14),
            DcTextField(
                label: 'Roll Number *',
                controller: rollCtrl),
            const SizedBox(height: 14),
            hostelsAsync.when(
              loading: () => const DcLoading(),
              error: (e, _) => Text('Could not load hostels: $e',
                  style: const TextStyle(color: AppColors.error)),
              data: (hostels) => DropdownButtonFormField<String>(
                value: selectedHostelId,
                decoration: InputDecoration(
                  labelText: 'Hostel *',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                ),
                items: hostels
                    .map((h) => DropdownMenuItem(value: h.id, child: Text(h.name)))
                    .toList(),
                onChanged: (v) { if (v != null) onHostelSelected(v); },
              ),
            ),
            const SizedBox(height: 14),
            DcTextField(
                label: 'Room Number *',
                controller: roomCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
            const SizedBox(height: 32),
            DcButton(label: 'Next: Guardian Info', onPressed: onNext),
          ],
        ),
      );
}

class _Step2 extends StatelessWidget {
  final TextEditingController nameCtrl, phoneCtrl;
  final String relation;
  final ValueChanged<String> onRelationChanged;
  final VoidCallback onSubmit;
  final bool loading;

  const _Step2({
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.relation,
    required this.onRelationChanged,
    required this.onSubmit,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Guardian Info',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
            const SizedBox(height: 8),
            const Text(
              'Your guardian will be able to track your movement via the DormConnect Parent app.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            DcTextField(
                label: 'Guardian Name *',
                controller: nameCtrl),
            const SizedBox(height: 14),
            DcTextField(
                label: 'Guardian Phone *',
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ]),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: relation,
              decoration: InputDecoration(
                labelText: 'Relation',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: AppColors.surfaceVariant,
              ),
              items: ['Father', 'Mother', 'Brother', 'Sister', 'Uncle', 'Aunt', 'Other']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) { if (v != null) onRelationChanged(v); },
            ),
            const SizedBox(height: 32),
            DcButton(
                label: 'Submit Registration',
                onPressed: onSubmit,
                isLoading: loading),
          ],
        ),
      );
}
