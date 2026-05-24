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
    _ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.isAuthenticated && prev?.isAuthenticated != true) {
        refresh();
      }
    });
    if (_ref.read(authProvider).isAuthenticated) refresh();
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final client = _ref.read(apiClientProvider);

      final results = await Future.wait([
        client.get('/api/v1/guardian/child/student'),
        client.get('/api/v1/guardian/child/leaves'),
      ]);

      final student = Student.fromJson(results[0].data as Map<String, dynamic>);

      final leaves = (results[1].data as List<dynamic>)
          .map((e) => LeaveApplication.fromJson(e as Map<String, dynamic>))
          .toList();

      // Fetch movements separately using the student's ID
      List<MovementLog> movements = [];
      try {
        final movResp = await client.get(
          '/api/v1/gate/history/${student.id}',
          params: {'limit': 10},
        );
        movements = (movResp.data as List<dynamic>)
            .map((e) => MovementLog.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {}

      state = ChildState(
        student: student,
        recentMovements: movements,
        activeLeaves: leaves,
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
