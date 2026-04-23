import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoingOutSheet extends StatefulWidget {
  final void Function(String? destination, DateTime? expectedReturn) onGenerate;

  const GoingOutSheet({super.key, required this.onGenerate});

  @override
  State<GoingOutSheet> createState() => _GoingOutSheetState();
}

class _GoingOutSheetState extends State<GoingOutSheet> {
  String? _destination;
  final _otherCtrl = TextEditingController();
  DateTime? _expectedReturn;

  static const _destinations = ['Home', 'Market', 'Hospital', 'College'];

  @override
  void dispose() {
    _otherCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickReturnTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 7)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
        context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    setState(() {
      _expectedReturn = DateTime(
          date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  String? get _resolvedDestination {
    if (_destination == null) return null;
    if (_destination == 'Other') return _otherCtrl.text.trim();
    return _destination;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Where are you going?',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._destinations.map((d) => ChoiceChip(
                  label: Text(d),
                  selected: _destination == d,
                  onSelected: (_) => setState(() => _destination = d),
                )),
            ChoiceChip(
              label: const Text('Other'),
              selected: _destination == 'Other',
              onSelected: (_) => setState(() => _destination = 'Other'),
            ),
          ],
        ),
        if (_destination == 'Other') ...[
          const SizedBox(height: 12),
          TextField(
            controller: _otherCtrl,
            decoration: InputDecoration(
              labelText: 'Destination',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: AppColors.surfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 16),
        const Text('Expected return time (optional)',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _pickReturnTime,
          icon: const Icon(Icons.schedule_rounded, size: 18),
          label: Text(
            _expectedReturn == null
                ? 'Pick return time'
                : DateFormat('dd MMM, hh:mm a').format(_expectedReturn!),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () =>
                widget.onGenerate(_resolvedDestination, _expectedReturn),
            icon: const Icon(Icons.qr_code_2_rounded),
            label: const Text('Generate OTP',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600)),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}
