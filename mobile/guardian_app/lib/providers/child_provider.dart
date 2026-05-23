import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChildState {
  final Student? student;
  final List<MovementLog> recentMovements;
  final List<LeaveApplication> activeLeaves;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const ChildState({
    this.student,
    this.recentMovements = const [],
    this.activeLeaves = const [],
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  ChildState copyWith({
    Student? student,
    List<MovementLog>? recentMovements,
    List<LeaveApplication>? activeLeaves,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) =>
      ChildState(
        student: student ?? this.student,
        recentMovements: recentMovements ?? this.recentMovements,
        activeLeaves: activeLeaves ?? this.activeLeaves,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  bool get isInHostel => student?.currentStatus == StudentStatus.inHostel;
}

class ChildNotifier extends StateNotifier<ChildState> {
  final Ref _ref;

  ChildNotifier(this._ref) : super(const ChildState()) {
    refresh();
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await Future.wait([
        _ref.read(studentApiProvider).getProfile(),
        _ref.read(gateApiProvider).getHistory(limit: 5),
        _ref.read(leaveApiProvider).list(limit: 10),
      ]);
      state = ChildState(
        student: results[0] as Student,
        recentMovements: results[1] as List<MovementLog>,
        activeLeaves: results[2] as List<LeaveApplication>,
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final childProvider =
    StateNotifierProvider<ChildNotifier, ChildState>(ChildNotifier.new);
