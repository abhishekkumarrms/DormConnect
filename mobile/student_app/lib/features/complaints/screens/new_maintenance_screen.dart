import 'dart:io';
import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class NewMaintenanceScreen extends ConsumerStatefulWidget {
  const NewMaintenanceScreen({super.key});

  @override
  ConsumerState<NewMaintenanceScreen> createState() =>
      _NewMaintenanceScreenState();
}

class _NewMaintenanceScreenState
    extends ConsumerState<NewMaintenanceScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  MaintenanceCategory _category = MaintenanceCategory.other;
  File? _photo;
  bool _loading = false;

  static const _categories = [
    (cat: MaintenanceCategory.plumbing, icon: Icons.water_drop_outlined, label: 'Plumbing'),
    (cat: MaintenanceCategory.electrical, icon: Icons.electrical_services_outlined, label: 'Electrical'),
    (cat: MaintenanceCategory.carpentry, icon: Icons.handyman_outlined, label: 'Carpentry'),
    (cat: MaintenanceCategory.painting, icon: Icons.format_paint_outlined, label: 'Painting'),
    (cat: MaintenanceCategory.civil, icon: Icons.foundation_outlined, label: 'Civil'),
    (cat: MaintenanceCategory.appliance, icon: Icons.kitchen_outlined, label: 'Appliance'),
    (cat: MaintenanceCategory.other, icon: Icons.build_outlined, label: 'Other'),
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
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
      final api = ref.read(maintenanceApiProvider);
      if (_photo != null) {
        final formData = FormData.fromMap({
          'category': _category.name,
          'title': _titleCtrl.text.trim(),
          'description': _descCtrl.text.trim(),
          if (_locationCtrl.text.trim().isNotEmpty)
            'location': _locationCtrl.text.trim(),
          'photo': await MultipartFile.fromFile(_photo!.path,
              filename: 'photo.jpg'),
        });
        await api.createWithPhoto(formData);
      } else {
        await api.create({
          'category': _category.name,
          'title': _titleCtrl.text.trim(),
          'description': _descCtrl.text.trim(),
          if (_locationCtrl.text.trim().isNotEmpty)
            'location': _locationCtrl.text.trim(),
        });
      }
      if (mounted) {
        DcSnackbar.success(context, 'Maintenance request submitted');
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
        title: const Text('Maintenance Request'),
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
                            ? AppColors.warning.withOpacity(0.1)
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? AppColors.warning
                              : AppColors.border,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(c.icon,
                              size: 20,
                              color: selected
                                  ? AppColors.warning
                                  : AppColors.textSecondary),
                          const SizedBox(height: 4),
                          Text(c.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                                color: selected
                                    ? AppColors.warning
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
                label: 'Title *',
                controller: _titleCtrl,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 14),
              DcTextField(
                label: 'Description (min 20 characters) *',
                controller: _descCtrl,
                maxLines: 3,
                validator: (v) {
                  if (v == null || v.trim().length < 20) {
                    return 'Description must be at least 20 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              DcTextField(
                label: 'Location / Room (optional)',
                controller: _locationCtrl,
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
                    border: Border.all(color: AppColors.border),
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
                label: 'Submit Request',
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
