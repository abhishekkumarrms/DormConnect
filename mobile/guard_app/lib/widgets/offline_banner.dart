import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OfflineBanner extends StatelessWidget {
  final DateTime lastSyncAt;
  const OfflineBanner({super.key, required this.lastSyncAt});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFBBF24), // amber-400
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: [
        const Icon(Icons.wifi_off_rounded, size: 16, color: Colors.black87),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '⚠️  No network — Showing last synced data. '
            'Last sync: ${DateFormat('h:mm a').format(lastSyncAt)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ]),
    );
  }
}
