import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ── Models ──────────────────────────────────────────────────────────────────

class PendingRequest {
  final String studentId;
  final String studentName;
  final String roomNumber;
  final String? photoUrl;
  final String otp;
  final String movementType; // 'OUT' | 'IN'
  final String? destination;
  final String? expectedReturn;
  final int expiresInSeconds;

  const PendingRequest({
    required this.studentId,
    required this.studentName,
    required this.roomNumber,
    this.photoUrl,
    required this.otp,
    required this.movementType,
    this.destination,
    this.expectedReturn,
    required this.expiresInSeconds,
  });

  factory PendingRequest.fromJson(Map<String, dynamic> j) => PendingRequest(
        studentId: j['student_id'] as String,
        studentName: j['student_name'] as String? ?? 'Unknown',
        roomNumber: j['room_number'] as String? ?? '—',
        photoUrl: j['photo_url'] as String?,
        otp: j['otp'] as String? ?? '',
        movementType: (j['movement_type'] as String? ?? 'OUT').toUpperCase(),
        destination: j['destination'] as String?,
        expectedReturn: j['expected_return'] as String?,
        expiresInSeconds: j['expires_in_seconds'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'student_name': studentName,
        'room_number': roomNumber,
        'photo_url': photoUrl,
        'otp': otp,
        'movement_type': movementType,
        'destination': destination,
        'expected_return': expectedReturn,
        'expires_in_seconds': expiresInSeconds,
      };
}

class OnLeaveStudent {
  final String studentId;
  final String studentName;
  final String roomNumber;
  final String leaveId;

  const OnLeaveStudent({
    required this.studentId,
    required this.studentName,
    required this.roomNumber,
    required this.leaveId,
  });

  factory OnLeaveStudent.fromJson(Map<String, dynamic> j) => OnLeaveStudent(
        studentId: j['student_id'] as String,
        studentName: j['student_name'] as String? ?? 'Unknown',
        roomNumber: j['room_number'] as String? ?? '—',
        leaveId: j['leave_id'] as String,
      );

  PendingRequest toExitRequest() => PendingRequest(
        studentId: studentId,
        studentName: studentName,
        roomNumber: roomNumber,
        otp: '',
        movementType: 'LEAVE',
        expiresInSeconds: 0,
      );
}

class ShiftLogEntry {
  final String id;
  final String studentName;
  final String roomNumber;
  final String movementType;
  final String? destination;
  final bool isFlagged;
  final bool isOverdue;
  final DateTime? createdAt;
  final bool wasManual;

  const ShiftLogEntry({
    required this.id,
    required this.studentName,
    required this.roomNumber,
    required this.movementType,
    this.destination,
    required this.isFlagged,
    required this.isOverdue,
    this.createdAt,
    this.wasManual = false,
  });

  factory ShiftLogEntry.fromJson(Map<String, dynamic> j) => ShiftLogEntry(
        id: j['id'] as String,
        studentName: j['student_name'] as String? ?? 'Unknown',
        roomNumber: j['room_number'] as String? ?? '—',
        movementType: (j['movement_type'] as String? ?? 'OUT').toUpperCase(),
        destination: j['destination'] as String?,
        isFlagged: j['is_flagged'] as bool? ?? false,
        isOverdue: j['is_overdue'] as bool? ?? false,
        createdAt: j['created_at'] != null
            ? DateTime.tryParse(j['created_at'] as String)
            : null,
        wasManual: false,
      );
}

class ConfirmedEntry {
  final String studentName;
  final String roomNumber;
  final String movementType;
  final DateTime confirmedAt;
  final bool wasManual;

  const ConfirmedEntry({
    required this.studentName,
    required this.roomNumber,
    required this.movementType,
    required this.confirmedAt,
    this.wasManual = false,
  });

  Map<String, dynamic> toJson() => {
        'studentName': studentName,
        'roomNumber': roomNumber,
        'movementType': movementType,
        'confirmedAt': confirmedAt.toIso8601String(),
        'wasManual': wasManual,
      };

  factory ConfirmedEntry.fromJson(Map<String, dynamic> j) => ConfirmedEntry(
        studentName: j['studentName'] as String,
        roomNumber: j['roomNumber'] as String,
        movementType: j['movementType'] as String,
        confirmedAt: DateTime.parse(j['confirmedAt'] as String),
        wasManual: j['wasManual'] as bool? ?? false,
      );
}

// ── State ────────────────────────────────────────────────────────────────────

class GateState {
  final List<PendingRequest> exitRequests;
  final List<PendingRequest> entryRequests;
  final List<OnLeaveStudent> onLeaveStudents;
  final int totalOutCount;
  final bool isOnline;
  final DateTime lastSyncAt;
  final List<ConfirmedEntry> recentConfirms;
  final int offlineQueueCount;
  final bool isLoading;
  final String? error;

  const GateState({
    this.exitRequests = const [],
    this.entryRequests = const [],
    this.onLeaveStudents = const [],
    this.totalOutCount = 0,
    this.isOnline = true,
    required this.lastSyncAt,
    this.recentConfirms = const [],
    this.offlineQueueCount = 0,
    this.isLoading = false,
    this.error,
  });

  int get studentsOutCount => totalOutCount;

  GateState copyWith({
    List<PendingRequest>? exitRequests,
    List<PendingRequest>? entryRequests,
    List<OnLeaveStudent>? onLeaveStudents,
    int? totalOutCount,
    bool? isOnline,
    DateTime? lastSyncAt,
    List<ConfirmedEntry>? recentConfirms,
    int? offlineQueueCount,
    bool? isLoading,
    String? error,
  }) =>
      GateState(
        exitRequests: exitRequests ?? this.exitRequests,
        entryRequests: entryRequests ?? this.entryRequests,
        onLeaveStudents: onLeaveStudents ?? this.onLeaveStudents,
        totalOutCount: totalOutCount ?? this.totalOutCount,
        isOnline: isOnline ?? this.isOnline,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        recentConfirms: recentConfirms ?? this.recentConfirms,
        offlineQueueCount: offlineQueueCount ?? this.offlineQueueCount,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class GateNotifier extends StateNotifier<GateState> {
  final Ref _ref;
  Timer? _pollTimer;
  StreamSubscription? _connectivitySub;

  static const _boxCache = 'gate_cache_v2';
  static const _boxQueue = 'gate_offline_queue';
  static const _boxLog = 'gate_session_log';

  GateNotifier(this._ref) : super(GateState(lastSyncAt: DateTime.now())) {
    _init();
  }

  Future<void> _init() async {
    await Hive.openBox<String>(_boxCache);
    await Hive.openBox<String>(_boxQueue);
    await Hive.openBox<String>(_boxLog);
    _loadCachedRequests();
    _loadLog();
    _startPolling();
    _watchConnectivity();
    await fetchRequests();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) {
        if (state.isOnline) fetchRequests();
      },
    );
  }

  void _watchConnectivity() {
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      final online = results.any((r) => r != ConnectivityResult.none);
      state = state.copyWith(isOnline: online);
      if (online) {
        _flushOfflineQueue();
        fetchRequests();
      }
    });
  }

  void _loadCachedRequests() {
    final box = Hive.box<String>(_boxCache);
    final raw = box.get('live_requests');
    if (raw == null) return;
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      state = state.copyWith(
        exitRequests: _parseRequests(j['exit_requests']),
        entryRequests: _parseRequests(j['entry_requests']),
        onLeaveStudents: _parseOnLeave(j['on_leave_students']),
        totalOutCount: j['total_out_count'] as int? ?? 0,
      );
    } catch (_) {}
  }

  void _loadLog() {
    final box = Hive.box<String>(_boxLog);
    final entries = box.values
        .map((s) {
          try {
            return ConfirmedEntry.fromJson(jsonDecode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<ConfirmedEntry>()
        .toList()
      ..sort((a, b) => b.confirmedAt.compareTo(a.confirmedAt));
    state = state.copyWith(recentConfirms: entries);
  }

  List<PendingRequest> _parseRequests(dynamic list) {
    if (list == null) return [];
    return (list as List)
        .map((e) => PendingRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<OnLeaveStudent> _parseOnLeave(dynamic list) {
    if (list == null) return [];
    return (list as List)
        .map((e) => OnLeaveStudent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> fetchRequests() async {
    if (state.isLoading) return;
    final hostelId = _ref.read(authProvider).user?.hostelId;
    if (hostelId == null) return;

    try {
      final resp = await _ref
          .read(apiClientProvider)
          .get('/api/v1/gate/live-requests', params: {'hostel_id': hostelId});

      final j = resp.data as Map<String, dynamic>;
      final exitReqs = _parseRequests(j['exit_requests']);
      final entryReqs = _parseRequests(j['entry_requests']);
      final onLeave = _parseOnLeave(j['on_leave_students']);
      final totalOut = j['total_out_count'] as int? ?? 0;

      // Cache to Hive
      final box = Hive.box<String>(_boxCache);
      await box.put('live_requests', jsonEncode(j));

      state = state.copyWith(
        exitRequests: exitReqs,
        entryRequests: entryReqs,
        onLeaveStudents: onLeave,
        totalOutCount: totalOut,
        isOnline: true,
        lastSyncAt: DateTime.now(),
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isOnline: false, error: e.toString());
    }
  }

  Future<bool> confirmPassage(PendingRequest request) async {
    // Optimistic: remove from whichever list
    state = state.copyWith(
      exitRequests:
          state.exitRequests.where((r) => r.studentId != request.studentId).toList(),
      entryRequests:
          state.entryRequests.where((r) => r.studentId != request.studentId).toList(),
    );

    if (!state.isOnline) {
      final box = Hive.box<String>(_boxQueue);
      await box.add(jsonEncode({
        'type': 'otp',
        'student_id': request.studentId,
        'otp': request.otp,
        'movement_type': request.movementType,
        'queuedAt': DateTime.now().toIso8601String(),
      }));
      state = state.copyWith(offlineQueueCount: state.offlineQueueCount + 1);
      _addToLog(request.studentName, request.roomNumber, request.movementType, false);
      return true;
    }

    try {
      await _ref.read(apiClientProvider).post('/api/v1/gate/confirm', data: {
        'student_id': request.studentId,
        'otp': request.otp,
        'movement_type': request.movementType,
      });
      _addToLog(request.studentName, request.roomNumber, request.movementType, false);
      return true;
    } catch (e) {
      // Restore
      state = state.copyWith(
        exitRequests: request.movementType == 'OUT'
            ? [...state.exitRequests, request]
            : state.exitRequests,
        entryRequests: request.movementType == 'IN'
            ? [...state.entryRequests, request]
            : state.entryRequests,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> manualEntry(
      String roomNumber, String movementType, String? note) async {
    try {
      await _ref.read(apiClientProvider).post('/api/v1/gate/manual-entry', data: {
        'room_number': roomNumber,
        'movement_type': movementType,
        if (note != null && note.isNotEmpty) 'note': note,
      });
      _addToLog('Room $roomNumber', roomNumber, movementType, true);
      return true;
    } catch (e) {
      if (!state.isOnline) {
        final box = Hive.box<String>(_boxQueue);
        await box.add(jsonEncode({
          'type': 'manual',
          'roomNumber': roomNumber,
          'movementType': movementType,
          'note': note,
          'queuedAt': DateTime.now().toIso8601String(),
        }));
        state = state.copyWith(offlineQueueCount: state.offlineQueueCount + 1);
        _addToLog('Room $roomNumber', roomNumber, movementType, true);
        return true;
      }
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  void _addToLog(String name, String room, String type, bool manual) {
    final entry = ConfirmedEntry(
      studentName: name,
      roomNumber: room,
      movementType: type,
      confirmedAt: DateTime.now(),
      wasManual: manual,
    );
    final box = Hive.box<String>(_boxLog);
    box.add(jsonEncode(entry.toJson()));
    state = state.copyWith(
      recentConfirms: [entry, ...state.recentConfirms],
    );
  }

  Future<void> _flushOfflineQueue() async {
    final box = Hive.box<String>(_boxQueue);
    if (box.isEmpty) return;
    final items = box.values.toList();
    await box.clear();
    state = state.copyWith(offlineQueueCount: 0);
    for (final raw in items) {
      try {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        if (j['type'] == 'manual') {
          await _ref.read(apiClientProvider).post('/api/v1/gate/manual-entry', data: {
            'room_number': j['roomNumber'],
            'movement_type': j['movementType'],
            if (j['note'] != null) 'note': j['note'],
          });
        } else {
          await _ref.read(apiClientProvider).post('/api/v1/gate/confirm', data: {
            'student_id': j['student_id'],
            'otp': j['otp'],
            'movement_type': j['movement_type'],
          });
        }
      } catch (_) {}
    }
  }

  Future<void> refresh() => fetchRequests();

  @override
  void dispose() {
    _pollTimer?.cancel();
    _connectivitySub?.cancel();
    super.dispose();
  }
}

final gateProvider =
    StateNotifierProvider<GateNotifier, GateState>((ref) => GateNotifier(ref));

// ── Shift log FutureProvider ─────────────────────────────────────────────────

final shiftLogProvider = FutureProvider.autoDispose<List<ShiftLogEntry>>((ref) async {
  final hostelId = ref.read(authProvider).user?.hostelId;
  if (hostelId == null) return [];
  final resp = await ref
      .read(apiClientProvider)
      .get('/api/v1/gate/shift-log', params: {'hostel_id': hostelId});
  final j = resp.data as Map<String, dynamic>;
  final logs = j['logs'] as List<dynamic>? ?? [];
  return logs.map((e) => ShiftLogEntry.fromJson(e as Map<String, dynamic>)).toList();
});
