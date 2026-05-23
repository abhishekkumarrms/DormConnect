import 'package:flutter/material.dart';

class AppColors {
  // Primary — deep navy
  static const Color primary = Color(0xFF1E3A5F);
  static const Color primaryDark = Color(0xFF152B47);
  static const Color primaryLight = Color(0xFF2A5080);

  // Secondary — teal accent
  static const Color secondary = Color(0xFF2DD4BF);
  static const Color secondaryDark = Color(0xFF14B8A4);

  // Semantics
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Light mode
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF1F5F9);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textTertiaryLight = Color(0xFF94A3B8);

  // Dark mode
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceVariantDark = Color(0xFF334155);
  static const Color borderDark = Color(0xFF475569);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);

  // Convenience aliases (light mode defaults)
  static const Color background = backgroundLight;
  static const Color surface = surfaceLight;
  static const Color surfaceVariant = surfaceVariantLight;
  static const Color border = borderLight;
  static const Color divider = borderLight;
  static const Color textPrimary = textPrimaryLight;
  static const Color textSecondary = textSecondaryLight;
  static const Color textTertiary = textTertiaryLight;
  static const Color textInverse = Color(0xFFFFFFFF);

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'submitted':
      case 'underreview':
        return warning;
      case 'approved':
      case 'resolved':
      case 'fixed':
      case 'active':
      case 'inhostel':
        return success;
      case 'rejected':
      case 'cannotfix':
        return error;
      case 'inprogress':
      case 'accepted':
      case 'inside':
      case 'guardiancontacted':
        return info;
      case 'escalated':
      case 'important':
        return const Color(0xFF8B5CF6);
      default:
        return textSecondaryLight;
    }
  }

  static Color healthScore(double score) {
    if (score >= 80) return success;
    if (score >= 60) return warning;
    return error;
  }
}
