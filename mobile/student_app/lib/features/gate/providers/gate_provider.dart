import 'dart:async';
import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum OtpStatus { idle, loading, active, expired }

class GateState {
  final OtpStatus status;
  final GateOtp? otp;
  final int secondsLeft;
  final String? error;

  const GateState({
    this.status = OtpStatus.idle,
    this.otp,
    this.secondsLeft = 0,
    this.error,
  });

  GateState copyWith({
    OtpStatus? status,
    GateOtp? otp,
    int? secondsLeft,
    String? error,
  }) =>
      GateState(
        status: status ?? this.status,
        otp: otp ?? this.otp,
        secondsLeft: secondsLeft ?? this.secondsLeft,
        error: error,
      );
}

class GateNotifier extends StateNotifier<GateState> {
  final Ref _ref;
  Timer? _timer;

  GateNotifier(this._ref) : super(const GateState());

  Future<void> generateOtp({
    required String movementType,
    String? destination,
    DateTime? expectedReturn,
  }) async {
    state = state.copyWith(status: OtpStatus.loading, error: null);
    try {
      final otp = await _ref.read(gateApiProvider).generateOtp(
            movementType: movementType,
            destination: destination,
            expectedReturn: expectedReturn,
          );
      state = state.copyWith(
        status: OtpStatus.active,
        otp: otp,
        secondsLeft: otp.expiresInSeconds,
      );
      _startCountdown();
    } catch (e) {
      String msg = e.toString();
      if (msg.contains('DioException') || msg.contains('detail')) {
        msg = 'Could not generate OTP. Check your connection.';
      }
      state = state.copyWith(status: OtpStatus.idle, error: msg);
    }
  }

  void cancelOtp() {
    _timer?.cancel();
    state = const GateState();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final left = state.secondsLeft - 1;
      if (left <= 0) {
        t.cancel();
        if (mounted) state = state.copyWith(status: OtpStatus.expired, secondsLeft: 0);
      } else {
        if (mounted) state = state.copyWith(secondsLeft: left);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final gateNotifierProvider =
    StateNotifierProvider<GateNotifier, GateState>((ref) => GateNotifier(ref));
