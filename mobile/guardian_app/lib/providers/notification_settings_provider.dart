import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationSettings {
  final bool leaveAlerts;
  final bool movementAlerts;
  final bool sosAlerts;
  final bool quietHoursEnabled;
  final int quietStart; // 0–23 hour
  final int quietEnd;   // 0–23 hour

  const NotificationSettings({
    this.leaveAlerts = true,
    this.movementAlerts = true,
    this.sosAlerts = true,
    this.quietHoursEnabled = false,
    this.quietStart = 22,
    this.quietEnd = 7,
  });

  bool get isQuietNow {
    if (!quietHoursEnabled) return false;
    final now = DateTime.now().hour;
    if (quietStart <= quietEnd) {
      return now >= quietStart && now < quietEnd;
    }
    // Overnight range e.g. 22–7
    return now >= quietStart || now < quietEnd;
  }

  NotificationSettings copyWith({
    bool? leaveAlerts,
    bool? movementAlerts,
    bool? sosAlerts,
    bool? quietHoursEnabled,
    int? quietStart,
    int? quietEnd,
  }) =>
      NotificationSettings(
        leaveAlerts: leaveAlerts ?? this.leaveAlerts,
        movementAlerts: movementAlerts ?? this.movementAlerts,
        sosAlerts: sosAlerts ?? this.sosAlerts,
        quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
        quietStart: quietStart ?? this.quietStart,
        quietEnd: quietEnd ?? this.quietEnd,
      );

  Map<String, dynamic> toMap() => {
        'leaveAlerts': leaveAlerts,
        'movementAlerts': movementAlerts,
        'sosAlerts': sosAlerts,
        'quietHoursEnabled': quietHoursEnabled,
        'quietStart': quietStart,
        'quietEnd': quietEnd,
      };

  factory NotificationSettings.fromMap(Map<dynamic, dynamic> m) =>
      NotificationSettings(
        leaveAlerts: m['leaveAlerts'] as bool? ?? true,
        movementAlerts: m['movementAlerts'] as bool? ?? true,
        sosAlerts: m['sosAlerts'] as bool? ?? true,
        quietHoursEnabled: m['quietHoursEnabled'] as bool? ?? false,
        quietStart: m['quietStart'] as int? ?? 22,
        quietEnd: m['quietEnd'] as int? ?? 7,
      );
}

class NotificationSettingsNotifier
    extends StateNotifier<NotificationSettings> {
  static const _boxName = 'notif_settings';
  static const _key = 'settings';

  NotificationSettingsNotifier() : super(const NotificationSettings()) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox(_boxName);
    final raw = box.get(_key);
    if (raw != null) {
      state = NotificationSettings.fromMap(raw as Map);
    }
  }

  Future<void> _save() async {
    final box = await Hive.openBox(_boxName);
    await box.put(_key, state.toMap());
  }

  void toggle(String key, bool value) {
    switch (key) {
      case 'leaveAlerts':
        state = state.copyWith(leaveAlerts: value);
      case 'movementAlerts':
        state = state.copyWith(movementAlerts: value);
      case 'sosAlerts':
        state = state.copyWith(sosAlerts: value);
      case 'quietHoursEnabled':
        state = state.copyWith(quietHoursEnabled: value);
    }
    _save();
  }

  void setQuietHours(int start, int end) {
    state = state.copyWith(quietStart: start, quietEnd: end);
    _save();
  }
}

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
        (_) => NotificationSettingsNotifier());
