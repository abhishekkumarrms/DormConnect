import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.security_rounded,
                  size: 64, color: Color(0xFF38BDF8)),
              SizedBox(height: 20),
              Text(
                'DormConnect',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'GUARD',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF38BDF8),
                  letterSpacing: 3,
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Color(0xFF38BDF8),
                  strokeWidth: 2.5,
                ),
              ),
            ],
          ),
        ),
      );
}
