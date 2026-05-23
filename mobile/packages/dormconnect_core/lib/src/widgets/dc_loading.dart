import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DcLoading extends StatelessWidget {
  final String? message;
  const DcLoading({super.key, this.message});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message!, style: const TextStyle(color: AppColors.textSecondary)),
            ],
          ],
        ),
      );
}

class DcShimmerList extends StatelessWidget {
  final int count;
  const DcShimmerList({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, __) => Container(
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
}
