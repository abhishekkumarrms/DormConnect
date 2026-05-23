import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DcStatusChip extends StatelessWidget {
  final String status;
  final double fontSize;

  const DcStatusChip({super.key, required this.status, this.fontSize = 11});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.statusColor(status);
    final label = status.replaceAll('_', ' ').replaceAll(
        RegExp(r'(?<=[a-z])(?=[A-Z])'), ' ');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
