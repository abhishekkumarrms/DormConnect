import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NewBroadcastScreen extends ConsumerStatefulWidget {
  const NewBroadcastScreen({super.key});

  @override
  ConsumerState<NewBroadcastScreen> createState() =>
      _NewBroadcastScreenState();
}

class _NewBroadcastScreenState
    extends ConsumerState<NewBroadcastScreen> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  BroadcastCategory _category = BroadcastCategory.general;
  bool _hostelOnly = false;
  bool _loading = false;

  static const _categories = [
    (BroadcastCategory.general, 'General', Icons.campaign_outlined),
    (BroadcastCategory.important, 'Important',
        Icons.priority_high_rounded),
    (BroadcastCategory.mess, 'Mess', Icons.restaurant_outlined),
    (BroadcastCategory.holiday, 'Holiday',
        Icons.beach_access_outlined),
    (BroadcastCategory.event, 'Event', Icons.event_outlined),
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Broadcast'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Category',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories
                  .map((c) => ChoiceChip(
                        label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(c.$3, size: 14),
                              const SizedBox(width: 4),
                              Text(c.$2),
                            ]),
                        selected: _category == c.$1,
                        selectedColor:
                            AppColors.primary.withOpacity(0.15),
                        onSelected: (_) =>
                            setState(() => _category = c.$1),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            DcTextField(
              label: 'Title',
              controller: _titleCtrl,
            ),
            const SizedBox(height: 12),
            DcTextField(
              label: 'Message',
              controller: _bodyCtrl,
              maxLines: 5,
            ),
            const SizedBox(height: 12),
            if (user?.hostelId != null)
              SwitchListTile(
                value: _hostelOnly,
                onChanged: (v) => setState(() => _hostelOnly = v),
                title: const Text('Hostel only',
                    style: TextStyle(fontSize: 14)),
                subtitle: const Text(
                    'Send to your hostel only (vs. institution-wide)',
                    style: TextStyle(fontSize: 12)),
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
              ),
            const SizedBox(height: 20),
            DcButton(
              label: _loading ? 'Sending…' : 'Send Broadcast',
              onPressed: _loading ? null : _send,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _send() async {
    if (_titleCtrl.text.trim().isEmpty ||
        _bodyCtrl.text.trim().isEmpty) {
      DcSnackbar.error(context, 'Title and message are required');
      return;
    }
    setState(() => _loading = true);
    try {
      final user = ref.read(currentUserProvider);
      await ref.read(broadcastApiProvider).create({
        'title': _titleCtrl.text.trim(),
        'body': _bodyCtrl.text.trim(),
        'category': _category.name,
        if (_hostelOnly && user?.hostelId != null)
          'hostel_id': user!.hostelId,
      });
      if (mounted) {
        DcSnackbar.success(context, 'Broadcast sent');
        context.pop();
      }
    } catch (e) {
      if (mounted) DcSnackbar.error(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
