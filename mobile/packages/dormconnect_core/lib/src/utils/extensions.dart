import 'package:intl/intl.dart';

extension StringX on String {
  String get titleCase =>
      split(' ').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}').join(' ');

  String get snakeToTitle => replaceAll('_', ' ').titleCase;

  bool get isValidPhone => RegExp(r'^[6-9]\d{9}$').hasMatch(this);
}

extension DateTimeX on DateTime {
  String get formatted => DateFormat('dd MMM yyyy').format(this);
  String get formattedWithTime => DateFormat('dd MMM yyyy, hh:mm a').format(this);
  String get timeOnly => DateFormat('hh:mm a').format(this);
  String get iso => toIso8601String();

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}

extension NullableDateTimeX on DateTime? {
  String get formattedOrDash => this == null ? '—' : this!.formatted;
}

extension ListX<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
