import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DcBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool showDragHandle;

  const DcBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.showDragHandle = true,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget child,
    bool isDismissible = true,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DcBottomSheet(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle) ...[
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
          if (title != null) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    iconSize: 20,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
          ],
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: title != null ? 16 : 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
