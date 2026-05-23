import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_colors.dart';

class DcAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;

  const DcAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: CachedNetworkImageProvider(imageUrl!),
      );
    }
    final initials = name.trim().split(' ').take(2).map((w) => w[0]).join();
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary.withOpacity(0.15),
      child: Text(
        initials.toUpperCase(),
        style: TextStyle(
          fontSize: radius * 0.65,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
