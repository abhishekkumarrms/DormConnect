import 'package:flutter/material.dart';
import '../providers/gate_provider.dart';

const _exitBorder = Color(0xFFEF4444);  // red-500
const _entryBorder = Color(0xFF10B981); // emerald-500
const _leaveBorder = Color(0xFF2DD4BF); // teal-400
const _otpAmber = Color(0xFFF59E0B);    // amber-500

class RequestCard extends StatelessWidget {
  final PendingRequest request;
  final VoidCallback onTap;

  const RequestCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  Color get _borderColor => switch (request.movementType) {
        'in' => _entryBorder,
        'leave' => _leaveBorder,
        _ => _exitBorder,
      };

  Color get _otpColor => switch (request.movementType) {
        'in' => _entryBorder,
        _ => _otpAmber,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 72),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: _borderColor, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.studentName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Text(
                    'Rm ${request.roomNumber}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            if (request.movementType == 'leave')
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _leaveBorder.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _leaveBorder),
                ),
                child: const Text(
                  'ON LEAVE',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _leaveBorder,
                    letterSpacing: 0.5,
                  ),
                ),
              )
            else
              Text(
                request.otp,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: _otpColor,
                  fontFamily: 'monospace',
                  letterSpacing: 3,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
