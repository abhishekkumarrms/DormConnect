import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import '../providers/gate_provider.dart';

class OtpDisplayWidget extends StatelessWidget {
  final GateState gateState;
  final VoidCallback onCancel;

  const OtpDisplayWidget({
    super.key,
    required this.gateState,
    required this.onCancel,
  });

  String _formatSeconds(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '$m:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final otp = gateState.otp?.otp ?? '------';
    final expired = gateState.status == OtpStatus.expired;
    final seconds = gateState.secondsLeft;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: expired ? AppColors.surfaceVariant : AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            expired ? 'OTP Expired' : 'Show this to the guard',
            style: TextStyle(
              color: expired
                  ? AppColors.textSecondary
                  : Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: otp.split('').map((d) {
              return Container(
                width: 44,
                height: 56,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: expired ? AppColors.border : Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: expired
                        ? AppColors.textTertiary
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  d,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: expired ? AppColors.textTertiary : Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          if (!expired) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer_rounded,
                    size: 16,
                    color: seconds <= 30
                        ? AppColors.error
                        : Colors.white.withOpacity(0.8)),
                const SizedBox(width: 4),
                Text(
                  'Expires in ${_formatSeconds(seconds)}',
                  style: TextStyle(
                    color: seconds <= 30
                        ? AppColors.error
                        : Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: gateState.otp == null
                  ? 0
                  : seconds / gateState.otp!.expiresInSeconds,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(
                seconds <= 30 ? AppColors.error : Colors.white,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ] else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.timer_off_rounded,
                    size: 16, color: AppColors.textTertiary),
                SizedBox(width: 4),
                Text('OTP has expired',
                    style: TextStyle(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.close_rounded, size: 18),
            label: Text(expired ? 'Dismiss' : 'Cancel'),
            style: OutlinedButton.styleFrom(
              foregroundColor: expired ? AppColors.textSecondary : Colors.white,
              side: BorderSide(
                  color: expired
                      ? AppColors.border
                      : Colors.white.withOpacity(0.5)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
