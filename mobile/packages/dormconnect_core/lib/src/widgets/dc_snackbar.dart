import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DcSnackbar {
  static void show(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? AppColors.error : AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(16),
    ));
  }

  static void error(BuildContext context, String message) =>
      show(context, message, isError: true);

  static void success(BuildContext context, String message) =>
      show(context, message);
}
