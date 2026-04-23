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
  final String movementType; // 'out' | 'in'
  final DateTime requestedAt;
  final int secondsRemaining;

  const PendingRequest({
    required this.studentId,
    required this.studentName,
    required this.roomNumber,
    this.photoUrl,
    required this.otp,
    required this.movementType,
    required this.requestedAt,
    required this.secondsRemaining,
  });

  factory PendingRequest.fromLiveRequest(LiveRequest r) =>
      PendingRequest(
        studentId: r.studentId,
        studentName: r.studentName,
        roomNumber: r.roomNumber ?? '—',
        photoUrl: r.photoUrl,
        otp: r.otp,
        movementType: 'out',
        requestedAt: DateTime.now(),
        secondsRemaining: r.secondsRemaining,
      );

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'studentName': studentName,
        'roomNumber': roomNumber,
        'photoUrl': photoUrl,
        'otp': otp,
        'movementType': movementType,
        'requestedAt': requestedAt.toIso8601String(),
        'secondsRemaining': secondsRemaining,
      };

  factory PendingRequest.fromJson(Map<String, dynamic> j) =>
      PendingRequest(
        studentId: j['studentId'] as String,
        studentName: j['studentName'] as String,
        roomNumber: j['roomNumber'] as String,
        photoUrl: j['photoUrl'] as String?,
        otp: j['otp'] as String,
        movementType: j['movementType'] as String,
        requestedAt: DateTime.parse(j['requestedAt'] as String),
        secondsRemaining: j['secondsRemaining'] as int,
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

  factory ConfirmedEntry.fromJson(Map<String, dynamic> j) =>
      ConfirmedEntry(
        studentName: j['studentName'] as String,
        roomNumber: j['roomNumber'] as String,
        movementType: j['movementType'] as String,
        confirmedAt: DateTime.parse(j['confirmedAt'] as String),
        wasManual: j['wasManual'] as bool? ?? false,
      );
}

// Queued offline confirmation to sync later
class _OfflineItem {
  final String studentId;
  final String otp;
  final String movementType;
  final DateTime queuedAt;
  _OfflineItem(this.studentId, this.otp, this.movementType, this.queuedAt);

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'otp': otp,
        'movementType': movementType,
        'queuedAt': queuedAt.toIso8601String(),
      };
}

// ── State ────────────────────────────────────────────────────────────────────

class GateState {
  final List<PendingRequest> exitRequests;
  final List<MovementLog> liveOut;
  final bool isOnline;
  final DateTime lastSyncAt;
  final List<ConfirmedEntry> recentConfirms;
  final bool isLoading;
  final String? error;

  const GateState({
    this.exitRequests = const [],
    this.liveOut = const [],
    this.isOnline = true,
    required this.lastSyncAt,
    this.recentConfirms = const [],
    this.isLoading = false,
    this.error,
  });

  int get studentsOutCount => liveOut.length;

  GateState copyWith({
    List<PendingRequest>? exitRequests,
    List<MovementLog>? liveOut,
    bool? isOnline,
    DateTime? lastSyncAt,
    List<ConfirmedEntry>? recentConfirms,
    bool? isLoading,
    String? error,
  }) =>
      GateState(
        exitRequests: exitRequests ?? this.exitRequests,
        liveOut: liveOut ?? this.liveOut,
        isOnline: isOnline ?? this.isOnline,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        recentConfirms: recentConfirms ?? this.recentConfirms,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class GateNotifier extends StateNotifier<GateState> {
  final Ref _ref;
  Timer? _pollTimer;
  StreamSubscription? _connectivitySub;

  static const _boxRequests = 'gate_requests_cache';
  static const _boxQueue = 'gate_offline_queue';
  static const _boxLog = 'gate_session_log';

  GateNotifier(this._ref)
      : super(GateState(lastSyncAt: DateTime.now())) {
    _init();
  }

  Future<void> _init() async {
    await Hive.openBox<String>(_boxRequests);
    await Hive.openBox<String>(_boxQueue);
    await Hive.openBox<String>(_boxLog);
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
    _connectivitySub =
        Connectivity().onConnectivityChanged.listen((results) {
      final online = results.any((r) => r != ConnectivityResult.none);
      state = state.copyWith(isOnline: online);
      if (online) {
        _flushOfflineQueue();
        fetchRequests();
      }
    });
  }

  void _loadLog() {
    final box = Hive.box<String>(_boxLog);
    final entries = box.values
        .map((s) {
          try {
            return ConfirmedEntry.fromJson(
                jsonDecode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<ConfirmedEntry>()
        .toList()
      ..sort((a, b) => b.confirmedAt.compareTo(a.confirmedAt));
    state = state.copyWith(recentConfirms: entries);
  }

  Future<void> fetchRequests() async {
    if (state.isLoading) return;
    try {
      final gateApi = _ref.read(gateApiProvider);
      final results = await Future.wait([
        gateApi.getLiveRequests(),
        gateApi.getLiveOut(),
      ]);
      final requests = (results[0] as List<LiveRequest>)
          .map(PendingRequest.fromLiveRequest)
          .toList();
      final liveOut = results[1] as List<MovementLog>;

      // Cache to Hive
      final box = Hive.box<String>(_boxRequests);
      await box.put('requests',
          jsonEncode(requests.map((r) => r.toJson()).toList()));
      await box.put('liveout_count', liveOut.length.toString());

      state = state.copyWith(
        exitRequests: requests,
        liveOut: liveOut,
        isOnline: true,
        lastSyncAt: DateTime.now(),
        error: null,
      );
    } catch (e) {
      // Load from Hive cache
      final box = Hive.box<String>(_boxRequests);
      final cached = box.get('requests');
      List<PendingRequest> requests = [];
      if (cached != null) {
        try {
          requests = (jsonDecode(cached) as List)
              .map((e) =>
                  PendingRequest.fromJson(e as Map<String, dynamic>))
              .toList();
        } catch (_) {}
      }
      state = state.copyWith(
        exitRequests: requests,
        isOnline: false,
        error: e.toString(),
      );
    }
  }

  Future<bool> confirmPassage(PendingRequest request) async {
    // Optimistic: remove immediately
    state = state.copyWith(
      exitRequests: state.exitRequests
          .where((r) => r.otp != request.otp)
          .toList(),
    );

    if (!state.isOnline) {
      // Queue offline
      final item = _OfflineItem(
          request.studentId, request.otp, request.movementType, DateTime.now());
      final box = Hive.box<String>(_boxQueue);
      await box.add(jsonEncode(item.toJson()));
      _addToLog(request.studentName, request.roomNumber,
          request.movementType, false);
      return true;
    }

    try {
      await _ref.read(gateApiProvider).confirmOtp(request.otp);
      _addToLog(request.studentName, request.roomNumber,
          request.movementType, false);
      return true;
    } catch (e) {
      // Restore to list
      state = state.copyWith(
        exitRequests: [...state.exitRequests, request],
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> manualEntry(
      String roomNumber, String movementType, String? note) async {
    try {
      await _ref.read(apiClientProvider).post('/api/v1/gate/manual-entry',
          data: {
            'room_number': roomNumber,
            'movement_type': movementType,
            if (note != null && note.isNotEmpty) 'note': note,
          });
      _addToLog('Room $roomNumber', roomNumber, movementType, true);
      return true;
    } catch (e) {
      if (!state.isOnline) {
        // Queue offline
        final box = Hive.box<String>(_boxQueue);
        await box.add(jsonEncode({
          'type': 'manual',
          'roomNumber': roomNumber,
          'movementType': movementType,
          'note': note,
          'queuedAt': DateTime.now().toIso8601String(),
        }));
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
    for (final raw in items) {
      try {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        if (j['type'] == 'manual') {
          await _ref.read(apiClientProvider).post('/api/v1/gate/manual-entry',
              data: {
                'room_number': j['roomNumber'],
                'movement_type': j['movementType'],
                if (j['note'] != null) 'note': j['note'],
              });
        } else {
          await _ref
              .read(gateApiProvider)
              .confirmOtp(j['otp'] as String);
        }
      } catch (_) {
        // Skip failed items — already optimistically confirmed
      }
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
    StateNotifierProvider<GateNotifier, GateState>(
        (ref) => GateNotifier(ref));
