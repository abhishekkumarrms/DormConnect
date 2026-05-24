import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';

class GuardianSplashScreen extends StatelessWidget {
  const GuardianSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.family_restroom, size: 64, color: AppColors.success),
            SizedBox(height: 16),
            Text(
              'DormConnect',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary),
            ),
            Text(
              'Parent/Guardian Portal',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
