import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NewVisitorScreen extends ConsumerStatefulWidget {
  const NewVisitorScreen({super.key});

  @override
  ConsumerState<NewVisitorScreen> createState() => _NewVisitorScreenState();
}

class _NewVisitorScreenState extends ConsumerState<NewVisitorScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _purposeCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _relation = 'parent';
  DateTime? _visitDate;
  bool _loading = false;

  static const _relations = [
    'parent',
    'sibling',
    'relative',
    'friend',
    'guardian',
    'other',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _purposeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _visitDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_visitDate == null) {
      DcSnackbar.error(context, 'Select a visit date');
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(visitorApiProvider).request({
        'visitor_name': _nameCtrl.text.trim(),
        'visitor_phone': _phoneCtrl.text.trim(),
        'relation': _relation,
        'purpose': _purposeCtrl.text.trim(),
        'visit_date': _visitDate!.iso,
      });
      if (mounted) {
        DcSnackbar.success(context, 'Visitor pre-registered');
        context.go('/home/dashboard');
      }
    } catch (e) {
      if (mounted) DcSnackbar.error(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Visitor'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        size: 16, color: AppColors.info),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pre-registering visitors helps the gate guard verify and allow entry faster.',
                        style: TextStyle(
                            color: AppColors.info,
                            fontSize: 12,
                            height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              DcTextField(
                label: 'Visitor Name *',
                controller: _nameCtrl,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 14),
              DcTextField(
                label: 'Visitor Phone *',
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (v.trim().length < 10) {
                    return 'Enter valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('Relation',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _relations
                    .map((r) => ChoiceChip(
                          label: Text(r.snakeToTitle),
                          selected: _relation == r,
                          selectedColor:
                              AppColors.primary.withOpacity(0.15),
                          onSelected: (_) =>
                              setState(() => _relation = r),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text('Visit Date *',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_outlined, size: 16),
                label: Text(
                    _visitDate == null ? 'Select date' : fmt.format(_visitDate!)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _visitDate != null
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 16),
                  minimumSize: const Size(double.infinity, 0),
                ),
              ),
              const SizedBox(height: 14),
              DcTextField(
                label: 'Purpose of Visit (optional)',
                controller: _purposeCtrl,
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              DcButton(
                label: 'Register Visitor',
                onPressed: _submit,
                isLoading: _loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
