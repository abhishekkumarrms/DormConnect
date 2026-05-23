import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:dormconnect_core/dormconnect_core.dart';

class EnrollScreen extends ConsumerStatefulWidget {
  const EnrollScreen({super.key});
  @override
  ConsumerState<EnrollScreen> createState() => _EnrollScreenState();
}

class _EnrollScreenState extends ConsumerState<EnrollScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _rollCtrl = TextEditingController();
  final _roomCtrl = TextEditingController();
  final _courseCtrl = TextEditingController();
  final _hostelIdCtrl = TextEditingController();
  File? _photo;
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_nameCtrl, _phoneCtrl, _rollCtrl, _roomCtrl, _courseCtrl, _hostelIdCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (img != null) setState(() => _photo = File(img.path));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final formData = FormData.fromMap({
        'full_name': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'roll_number': _rollCtrl.text.trim(),
        'hostel_id': _hostelIdCtrl.text.trim(),
        'room_number': _roomCtrl.text.trim(),
        'course': _courseCtrl.text.trim(),
        if (_photo != null)
          'profile_photo': await MultipartFile.fromFile(_photo!.path),
      });
      await ref.read(studentApiProvider).enroll(formData);
      if (mounted) {
        DcSnackbar.success(context, 'Enrollment submitted! Await warden approval.');
        context.go('/login');
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
      appBar: AppBar(title: const Text('Student Enrollment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickPhoto,
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: _photo != null ? FileImage(_photo!) : null,
                  child: _photo == null
                      ? const Icon(Icons.camera_alt, size: 32,
                          color: AppColors.textSecondary)
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Tap to add photo',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              DcTextField(
                  label: 'Full Name',
                  controller: _nameCtrl,
                  validator: (v) => Validators.required(v, 'Name')),
              const SizedBox(height: 16),
              DcTextField(
                label: 'Phone',
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                validator: Validators.phone,
              ),
              const SizedBox(height: 16),
              DcTextField(
                  label: 'Roll Number',
                  controller: _rollCtrl,
                  validator: (v) => Validators.required(v, 'Roll Number')),
              const SizedBox(height: 16),
              DcTextField(
                  label: 'Hostel ID',
                  controller: _hostelIdCtrl,
                  validator: (v) => Validators.required(v, 'Hostel ID')),
              const SizedBox(height: 16),
              DcTextField(label: 'Room Number', controller: _roomCtrl),
              const SizedBox(height: 16),
              DcTextField(label: 'Course', controller: _courseCtrl),
              const SizedBox(height: 32),
              DcButton(
                  label: 'Submit Enrollment',
                  onPressed: _submit,
                  isLoading: _loading),
            ],
          ),
        ),
      ),
    );
  }
}
