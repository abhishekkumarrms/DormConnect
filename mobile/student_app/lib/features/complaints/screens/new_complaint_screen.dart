import 'dart:io';
import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class NewComplaintScreen extends ConsumerStatefulWidget {
  const NewComplaintScreen({super.key});

  @override
  ConsumerState<NewComplaintScreen> createState() =>
      _NewComplaintScreenState();
}

class _NewComplaintScreenState extends ConsumerState<NewComplaintScreen> {
  final _descCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ComplaintCategory _category = ComplaintCategory.food;
  File? _photo;
  bool _loading = false;

  static const _categories = [
    (cat: ComplaintCategory.food, icon: Icons.restaurant_outlined, label: 'Food'),
    (cat: ComplaintCategory.staffBehavior, icon: Icons.person_off_outlined, label: 'Staff'),
    (cat: ComplaintCategory.security, icon: Icons.security_outlined, label: 'Security'),
    (cat: ComplaintCategory.environment, icon: Icons.nature_outlined, label: 'Environment'),
    (cat: ComplaintCategory.ragging, icon: Icons.report_problem_outlined, label: 'Ragging'),
    (cat: ComplaintCategory.other, icon: Icons.more_horiz_rounded, label: 'Other'),
  ];

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final picked = await picker.pickImage(source: source, imageQuality: 70);
    if (picked != null) setState(() => _photo = File(picked.path));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final api = ref.read(complaintApiProvider);
      if (_photo != null) {
        final formData = FormData.fromMap({
          'category': _category.name,
          'description': _descCtrl.text.trim(),
          'photo': await MultipartFile.fromFile(_photo!.path,
              filename: 'photo.jpg'),
        });
        await api.createWithPhoto(formData);
      } else {
        await api.create({
          'category': _category.name,
          'description': _descCtrl.text.trim(),
        });
      }
      if (mounted) {
        DcSnackbar.success(context, 'Complaint submitted');
        context.go('/home/activity');
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
      appBar: AppBar(
        title: const Text('File a Complaint'),
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
              const Text('Category',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.9,
                children: _categories.map((c) {
                  final selected = _category == c.cat;
                  return GestureDetector(
                    onTap: () => setState(() => _category = c.cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.border,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(c.icon,
                              size: 24,
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textSecondary),
                          const SizedBox(height: 6),
                          Text(c.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              )),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              DcTextField(
                label: 'Description (min 30 characters) *',
                controller: _descCtrl,
                maxLines: 4,
                validator: (v) {
                  if (v == null || v.trim().length < 30) {
                    return 'Description must be at least 30 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('Attach Photo (optional)',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickPhoto,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: _photo != null ? 180 : 90,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.border, style: BorderStyle.solid),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _photo != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(_photo!, fit: BoxFit.cover),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () => setState(() => _photo = null),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(Icons.close_rounded,
                                      color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_photo_alternate_outlined,
                                size: 28,
                                color: AppColors.textTertiary),
                            SizedBox(height: 6),
                            Text('Tap to add photo',
                                style: TextStyle(
                                    color: AppColors.textTertiary,
                                    fontSize: 13)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 32),
              DcButton(
                label: 'Submit Complaint',
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
