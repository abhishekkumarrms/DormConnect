import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DcBadge extends StatelessWidget {
  final String label;
  final Color? color;

  const DcBadge({super.key, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.statusColor(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withOpacity(0.3)),
      ),
      child: Text(
        label.replaceAll('_', ' '),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: c,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
