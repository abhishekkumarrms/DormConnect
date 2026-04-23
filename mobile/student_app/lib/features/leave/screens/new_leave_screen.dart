import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NewLeaveScreen extends ConsumerStatefulWidget {
  const NewLeaveScreen({super.key});

  @override
  ConsumerState<NewLeaveScreen> createState() => _NewLeaveScreenState();
}

class _NewLeaveScreenState extends ConsumerState<NewLeaveScreen> {
  final _reasonCtrl = TextEditingController();
  final _destCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  LeaveType _type = LeaveType.home;
  DateTime? _from;
  DateTime? _to;
  bool _loading = false;

  @override
  void dispose() {
    _reasonCtrl.dispose();
    _destCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isFrom) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => isFrom ? _from = picked : _to = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_from == null || _to == null) {
      DcSnackbar.error(context, 'Select from and to dates');
      return;
    }
    if (_to!.isBefore(_from!)) {
      DcSnackbar.error(context, 'End date must be after start date');
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(leaveApiProvider).apply({
        'leave_type': _type.name,
        'from_date': _from!.iso,
        'to_date': _to!.iso,
        'reason': _reasonCtrl.text.trim(),
        if (_destCtrl.text.trim().isNotEmpty)
          'destination': _destCtrl.text.trim(),
        if (_contactCtrl.text.trim().isNotEmpty)
          'contact_during_leave': _contactCtrl.text.trim(),
      });
      if (mounted) {
        DcSnackbar.success(context, 'Leave application submitted');
        context.go('/leave');
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
        title: const Text('Apply for Leave'),
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
              const Text('Leave Type',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: LeaveType.values
                    .map((t) => ChoiceChip(
                          label: Text(t.name.snakeToTitle),
                          selected: _type == t,
                          selectedColor: AppColors.primary.withOpacity(0.15),
                          onSelected: (_) => setState(() => _type = t),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text('Date Range',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickDate(true),
                    icon: const Icon(Icons.calendar_today_outlined, size: 16),
                    label: Text(_from == null ? 'From' : fmt.format(_from!),
                        overflow: TextOverflow.ellipsis),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _from != null
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward_rounded,
                      color: AppColors.textTertiary),
                ),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickDate(false),
                    icon: const Icon(Icons.calendar_month_outlined, size: 16),
                    label: Text(_to == null ? 'To' : fmt.format(_to!),
                        overflow: TextOverflow.ellipsis),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _to != null
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              DcTextField(
                label: 'Reason (min 20 characters) *',
                controller: _reasonCtrl,
                maxLines: 3,
                validator: (v) {
                  if (v == null || v.trim().length < 20) {
                    return 'Reason must be at least 20 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              DcTextField(
                label: 'Destination (optional)',
                controller: _destCtrl,
              ),
              const SizedBox(height: 14),
              DcTextField(
                label: 'Contact During Leave (optional)',
                controller: _contactCtrl,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              DcButton(
                  label: 'Submit Application',
                  onPressed: _submit,
                  isLoading: _loading),
            ],
          ),
        ),
      ),
    );
  }
}
