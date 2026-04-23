import 'package:intl/intl.dart';

class DcDateUtils {
  static String formatDate(DateTime dt) =>
      DateFormat('d MMM yyyy').format(dt);

  static String formatDateTime(DateTime dt) =>
      DateFormat('d MMM yyyy, h:mm a').format(dt);

  static String formatTime(DateTime dt) =>
      DateFormat('h:mm a').format(dt);

  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m minute${m == 1 ? '' : 's'} ago';
    }
    if (diff.inHours < 24) {
      final h = diff.inHours;
      return '$h hour${h == 1 ? '' : 's'} ago';
    }
    final d = diff.inDays;
    if (d < 7) return '$d day${d == 1 ? '' : 's'} ago';
    return formatDate(dt);
  }

  static bool isOverdue(DateTime expectedReturn) =>
      DateTime.now().isAfter(expectedReturn);

  static String countdownString(DateTime expiresAt) {
    final remaining = expiresAt.difference(DateTime.now());
    if (remaining.isNegative) return '0:00';
    final m = remaining.inMinutes;
    final s = remaining.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  static String countdownFromSeconds(int seconds) {
    if (seconds <= 0) return '0:00';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
