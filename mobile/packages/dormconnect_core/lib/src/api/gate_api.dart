import 'api_client.dart';
import '../models/movement.dart';

class GateApi {
  final ApiClient _client;
  GateApi(this._client);

  Future<GateOtp> generateOtp({
    String? movementType,
    String? destination,
    DateTime? expectedReturn,
  }) async {
    final resp = await _client.post('/api/v1/gate/otp/generate', data: {
      if (movementType != null) 'movement_type': movementType,
      if (destination != null) 'destination': destination,
      if (expectedReturn != null) 'expected_return': expectedReturn.toIso8601String(),
    });
    return GateOtp.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> getOtpStatus() async {
    final resp = await _client.get('/api/v1/gate/otp/status');
    return resp.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> confirmOtp(String otp, {String? note}) async {
    final resp = await _client.post('/api/v1/gate/confirm', data: {
      'otp': otp,
      if (note != null) 'note': note,
    });
    return resp.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> manualEntry(
      String studentId, String movementType,
      {String? note}) async {
    final resp = await _client.post('/api/v1/gate/manual-entry', data: {
      'student_id': studentId,
      'movement_type': movementType,
      if (note != null) 'note': note,
    });
    return resp.data as Map<String, dynamic>;
  }

  Future<List<LiveRequest>> getLiveRequests({String? hostelId}) async {
    final resp = await _client.get('/api/v1/gate/live-requests',
        params: {if (hostelId != null) 'hostel_id': hostelId});
    // Backend returns {exit_requests, entry_requests, ...} — combine both lists
    final data = resp.data;
    if (data is Map) {
      final exit = (data['exit_requests'] as List? ?? []);
      final entry = (data['entry_requests'] as List? ?? []);
      return [...exit, ...entry]
          .map((e) => _liveRequestFromEnriched(e as Map<String, dynamic>))
          .toList();
    }
    // Legacy flat list fallback
    return (data as List<dynamic>)
        .map((e) => LiveRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  LiveRequest _liveRequestFromEnriched(Map<String, dynamic> e) =>
      LiveRequest(
        studentId: e['student_id'] as String,
        otp: e['otp'] as String? ?? '',
        studentName: e['student_name'] as String? ?? 'Unknown',
        roomNumber: e['room_number'] as String?,
        photoUrl: e['photo_url'] as String?,
        secondsRemaining: e['expires_in_seconds'] as int? ?? 0,
      );

  Future<List<MovementLog>> getLiveOut({String? hostelId}) async {
    final path = hostelId != null
        ? '/api/v1/gate/live-out/$hostelId'
        : '/api/v1/gate/live-out';
    final resp = await _client.get(path);
    final data = resp.data;
    // Backend returns {students_out: [...], total_out_count: N, overdue_count: N}
    final list = data is Map
        ? (data['students_out'] as List? ?? [])
        : data as List<dynamic>;
    return list.map((e) => MovementLog.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<MovementLog>> getHistory(
      {String? studentId, int page = 1, int limit = 50}) async {
    final path = studentId != null
        ? '/api/v1/gate/history/$studentId'
        : '/api/v1/gate/history';
    final resp = await _client
        .get(path, params: {'page': page, 'limit': limit});
    final list = resp.data as List<dynamic>;
    return list.map((e) => MovementLog.fromJson(e as Map<String, dynamic>)).toList();
  }
}
