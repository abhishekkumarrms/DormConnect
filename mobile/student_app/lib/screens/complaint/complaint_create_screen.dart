import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dormconnect_core/dormconnect_core.dart';

class ComplaintCreateScreen extends ConsumerStatefulWidget {
  const ComplaintCreateScreen({super.key});
  @override
  ConsumerState<ComplaintCreateScreen> createState() =>
      _ComplaintCreateScreenState();
}

class _ComplaintCreateScreenState
    extends ConsumerState<ComplaintCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  ComplaintCategory _category = ComplaintCategory.other;
  bool _loading = false;

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(complaintApiProvider).create({
        'category': _category.name,
        'subject': _subjectCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
      });
      if (mounted) {
        DcSnackbar.success(context, 'Complaint submitted');
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
    return Scaffold(
      appBar: AppBar(title: const Text('File Complaint')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Category',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: ComplaintCategory.values
                    .map((c) => ChoiceChip(
                          label: Text(c.name.snakeToTitle),
                          selected: _category == c,
                          onSelected: (_) => setState(() => _category = c),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              DcTextField(
                label: 'Subject',
                controller: _subjectCtrl,
                validator: (v) => Validators.required(v, 'Subject'),
              ),
              const SizedBox(height: 16),
              DcTextField(
                label: 'Description',
                controller: _descCtrl,
                maxLines: 5,
                validator: (v) => Validators.required(v, 'Description'),
              ),
              const SizedBox(height: 32),
              DcButton(
                  label: 'Submit',
                  onPressed: _submit,
                  isLoading: _loading),
            ],
          ),
        ),
      ),
    );
  }
}
