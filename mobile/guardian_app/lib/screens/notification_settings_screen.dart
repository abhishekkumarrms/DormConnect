import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notification_settings_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Notification Settings',
            style: TextStyle(
                color: Color(0xFF0F172A), fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'Alert Types',
            children: [
              _ToggleTile(
                icon: Icons.beach_access_outlined,
                label: 'Leave Updates',
                subtitle: 'When leave status changes',
                value: settings.leaveAlerts,
                onChanged: (v) => notifier.toggle('leaveAlerts', v),
              ),
              _ToggleTile(
                icon: Icons.directions_walk_outlined,
                label: 'Movement Alerts',
                subtitle: 'When student enters/exits hostel',
                value: settings.movementAlerts,
                onChanged: (v) => notifier.toggle('movementAlerts', v),
              ),
              _ToggleTile(
                icon: Icons.warning_amber_rounded,
                label: 'SOS Alerts',
                subtitle: 'Emergency alerts — always recommended',
                value: settings.sosAlerts,
                onChanged: (v) => notifier.toggle('sosAlerts', v),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Quiet Hours',
            children: [
              _ToggleTile(
                icon: Icons.nights_stay_outlined,
                label: 'Enable Quiet Hours',
                subtitle: settings.quietHoursEnabled
                    ? 'Muted ${settings.quietStart}:00 – ${settings.quietEnd}:00'
                    : 'Suppress non-SOS alerts at night',
                value: settings.quietHoursEnabled,
                onChanged: (v) => notifier.toggle('quietHoursEnabled', v),
              ),
              if (settings.quietHoursEnabled) ...[
                _TimePickerTile(
                  label: 'Start',
                  hour: settings.quietStart,
                  onChanged: (h) =>
                      notifier.setQuietHours(h, settings.quietEnd),
                ),
                _TimePickerTile(
                  label: 'End',
                  hour: settings.quietEnd,
                  onChanged: (h) =>
                      notifier.setQuietHours(settings.quietStart, h),
                ),
              ],
            ],
          ),
          if (settings.quietHoursEnabled && settings.isQuietNow)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Row(children: [
                Icon(Icons.nights_stay_outlined,
                    color: Color(0xFF6B7280), size: 16),
                SizedBox(width: 8),
                Text('Quiet hours active now',
                    style:
                        TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
              ]),
            ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B))),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(children: children),
          ),
        ],
      );
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => SwitchListTile(
        secondary: Icon(icon, color: const Color(0xFF6B7280), size: 22),
        title: Text(label,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                fontSize: 12, color: Color(0xFF6B7280))),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF10B981),
      );
}

class _TimePickerTile extends StatelessWidget {
  final String label;
  final int hour;
  final ValueChanged<int> onChanged;
  const _TimePickerTile(
      {required this.label, required this.hour, required this.onChanged});

  Future<void> _pick(BuildContext context) async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: 0),
      builder: (ctx, child) =>
          MediaQuery(data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true), child: child!),
    );
    if (result != null) onChanged(result.hour);
  }

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const Icon(Icons.access_time,
            color: Color(0xFF6B7280), size: 22),
        title: Text('$label time',
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600)),
        trailing: Text(
          '${hour.toString().padLeft(2, '0')}:00',
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A)),
        ),
        onTap: () => _pick(context),
      );
}
