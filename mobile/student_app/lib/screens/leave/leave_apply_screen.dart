import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

class LeaveApplyScreen extends ConsumerStatefulWidget {
  const LeaveApplyScreen({super.key});
  @override
  ConsumerState<LeaveApplyScreen> createState() => _LeaveApplyScreenState();
}

class _LeaveApplyScreenState extends ConsumerState<LeaveApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonCtrl = TextEditingController();
  final _destCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
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
    if (picked != null) setState(() => isFrom ? _from = picked : _to = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_from == null || _to == null) {
      DcSnackbar.error(context, 'Select from and to dates');
      return;
    }
    if (_to!.isBefore(_from!)) {
      DcSnackbar.error(context, 'To date must be after from date');
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(leaveApiProvider).apply({
        'leave_type': _type.name,
        'from_date': _from!.iso,
        'to_date': _to!.iso,
        'reason': _reasonCtrl.text.trim(),
        'destination': _destCtrl.text.trim(),
        'contact_during_leave': _contactCtrl.text.trim(),
      });
      if (mounted) {
        DcSnackbar.success(context, 'Leave application submitted');
        context.pop();
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
      appBar: AppBar(title: const Text('Apply for Leave')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Leave Type', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: LeaveType.values.map((t) => ChoiceChip(
                  label: Text(t.name),
                  selected: _type == t,
                  onSelected: (_) => setState(() => _type = t),
                )).toList(),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: _DateButton(
                    label: _from == null ? 'From Date' : fmt.format(_from!),
                    onTap: () => _pickDate(true),
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateButton(
                    label: _to == null ? 'To Date' : fmt.format(_to!),
                    onTap: () => _pickDate(false),
                    icon: Icons.calendar_month_outlined,
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              DcTextField(
                label: 'Reason',
                controller: _reasonCtrl,
                maxLines: 3,
                validator: (v) => Validators.required(v, 'Reason'),
              ),
              const SizedBox(height: 16),
              DcTextField(
                label: 'Destination',
                controller: _destCtrl,
              ),
              const SizedBox(height: 16),
              DcTextField(
                label: 'Contact During Leave',
                controller: _contactCtrl,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              DcButton(label: 'Submit Application', onPressed: _submit, isLoading: _loading),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData icon;
  const _DateButton({required this.label, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, overflow: TextOverflow.ellipsis),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      );
}
