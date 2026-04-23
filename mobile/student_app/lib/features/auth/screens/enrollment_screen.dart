import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

final _hostelsProvider = FutureProvider<List<Hostel>>((ref) async {
  final resp = await ref.watch(apiClientProvider).get('/api/v1/hostels');
  final list = resp.data as List<dynamic>;
  return list.map((e) => Hostel.fromJson(e as Map<String, dynamic>)).toList();
});

class EnrollmentScreen extends ConsumerStatefulWidget {
  const EnrollmentScreen({super.key});

  @override
  ConsumerState<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends ConsumerState<EnrollmentScreen> {
  final _pageCtrl = PageController();
  int _step = 0;

  // Step 1
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _rollCtrl = TextEditingController();
  final _roomCtrl = TextEditingController();
  String? _selectedHostelId;

  // Step 2
  final _guardianNameCtrl = TextEditingController();
  final _guardianPhoneCtrl = TextEditingController();
  String _guardianRelation = 'Father';

  // Step 3
  File? _receiptFile;
  String? _receiptFileName;
  bool _loading = false;

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _rollCtrl.dispose();
    _roomCtrl.dispose();
    _guardianNameCtrl.dispose();
    _guardianPhoneCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 2) {
      _pageCtrl.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _step++);
    }
  }

  void _back() {
    if (_step > 0) {
      _pageCtrl.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _step--);
    }
  }

  Future<void> _pickReceipt() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: const Text('Pick PDF'),
              onTap: () => Navigator.pop(context, 'pdf'),
            ),
          ],
        ),
      ),
    );
    if (result == null) return;
    if (result == 'camera') {
      final img = await ImagePicker().pickImage(source: ImageSource.camera);
      if (img != null) {
        setState(() {
          _receiptFile = File(img.path);
          _receiptFileName = img.name;
        });
      }
    } else if (result == 'gallery') {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img != null) {
        setState(() {
          _receiptFile = File(img.path);
          _receiptFileName = img.name;
        });
      }
    } else {
      final r = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['pdf', 'jpg', 'png']);
      if (r != null && r.files.isNotEmpty) {
        final f = r.files.first;
        if (f.path != null) {
          setState(() {
            _receiptFile = File(f.path!);
            _receiptFileName = f.name;
          });
        }
      }
    }
  }

  Future<void> _submit() async {
    if (_nameCtrl.text.trim().isEmpty ||
        _rollCtrl.text.trim().isEmpty ||
        _selectedHostelId == null) {
      DcSnackbar.error(context, 'Fill all required fields');
      return;
    }
    setState(() => _loading = true);
    try {
      final formData = FormData.fromMap({
        'name': _nameCtrl.text.trim(),
        'roll_number': _rollCtrl.text.trim(),
        'hostel_id': _selectedHostelId!,
        if (_roomCtrl.text.trim().isNotEmpty)
          'room_number': _roomCtrl.text.trim(),
        if (_emailCtrl.text.trim().isNotEmpty)
          'email': _emailCtrl.text.trim(),
        'guardian_name': _guardianNameCtrl.text.trim(),
        'guardian_phone': _guardianPhoneCtrl.text.trim(),
        'guardian_relation': _guardianRelation,
        if (_receiptFile != null)
          'fee_receipt': await MultipartFile.fromFile(
            _receiptFile!.path,
            filename: _receiptFileName ?? 'receipt',
          ),
      });
      await ref.read(studentApiProvider).enroll(formData);
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
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: _back)
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
                  nameCtrl: _nameCtrl,
                  emailCtrl: _emailCtrl,
                  rollCtrl: _rollCtrl,
                  roomCtrl: _roomCtrl,
                  selectedHostelId: _selectedHostelId,
                  onHostelSelected: (id, name) =>
                      setState(() {
                        _selectedHostelId = id;
                      }),
                  onNext: _next,
                  hostelsAsync: ref.watch(_hostelsProvider),
                ),
                _Step2(
                  nameCtrl: _guardianNameCtrl,
                  phoneCtrl: _guardianPhoneCtrl,
                  relation: _guardianRelation,
                  onRelationChanged: (v) =>
                      setState(() => _guardianRelation = v),
                  onNext: _next,
                ),
                _Step3(
                  receiptFile: _receiptFile,
                  receiptFileName: _receiptFileName,
                  onPick: _pickReceipt,
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
          children: List.generate(3, (i) {
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
                  if (i < 2)
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
  final TextEditingController nameCtrl, emailCtrl, rollCtrl, roomCtrl;
  final String? selectedHostelId;
  final void Function(String id, String name) onHostelSelected;
  final VoidCallback onNext;
  final AsyncValue<List<Hostel>> hostelsAsync;

  const _Step1({
    required this.nameCtrl,
    required this.emailCtrl,
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
            DcTextField(
                label: 'Full Name *',
                controller: nameCtrl,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 14),
            DcTextField(
                label: 'Roll Number *',
                controller: rollCtrl,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 14),
            DcTextField(
                label: 'Email (optional)',
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress),
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
                    .map((h) => DropdownMenuItem(
                        value: h.id, child: Text(h.name)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    final h = hostels.firstWhere((h) => h.id == v);
                    onHostelSelected(v, h.name);
                  }
                },
              ),
            ),
            const SizedBox(height: 14),
            DcTextField(label: 'Room Number (optional)', controller: roomCtrl),
            const SizedBox(height: 32),
            DcButton(label: 'Next', onPressed: onNext),
          ],
        ),
      );
}

class _Step2 extends StatelessWidget {
  final TextEditingController nameCtrl, phoneCtrl;
  final String relation;
  final ValueChanged<String> onRelationChanged;
  final VoidCallback onNext;

  const _Step2({
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.relation,
    required this.onRelationChanged,
    required this.onNext,
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
            const SizedBox(height: 20),
            DcTextField(label: 'Guardian Name', controller: nameCtrl),
            const SizedBox(height: 14),
            DcTextField(
                label: 'Guardian Phone',
                controller: phoneCtrl,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: relation,
              decoration: InputDecoration(
                labelText: 'Relation',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: AppColors.surfaceVariant,
              ),
              items: ['Father', 'Mother', 'Sibling', 'Spouse', 'Other']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) {
                if (v != null) onRelationChanged(v);
              },
            ),
            const SizedBox(height: 32),
            DcButton(label: 'Next', onPressed: onNext),
          ],
        ),
      );
}

class _Step3 extends StatelessWidget {
  final File? receiptFile;
  final String? receiptFileName;
  final VoidCallback onPick;
  final VoidCallback onSubmit;
  final bool loading;

  const _Step3({
    required this.receiptFile,
    required this.receiptFileName,
    required this.onPick,
    required this.onSubmit,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fee Receipt',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
            const SizedBox(height: 8),
            const Text('Upload your hostel fee receipt for verification.',
                style:
                    TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onPick,
              child: Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: receiptFile != null
                        ? AppColors.success
                        : AppColors.border,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.surfaceVariant,
                ),
                child: receiptFile != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.success, size: 40),
                          const SizedBox(height: 8),
                          Text(receiptFileName ?? 'File selected',
                              style: const TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 4),
                          const Text('Tap to change',
                              style: TextStyle(
                                  color: AppColors.textTertiary,
                                  fontSize: 12)),
                        ],
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file_outlined,
                              color: AppColors.textSecondary, size: 40),
                          SizedBox(height: 8),
                          Text('Tap to upload',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 4),
                          Text('Photo, Gallery or PDF',
                              style: TextStyle(
                                  color: AppColors.textTertiary,
                                  fontSize: 12)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 32),
            DcButton(
                label: 'Submit Application',
                onPressed: onSubmit,
                isLoading: loading),
          ],
        ),
      );
}
