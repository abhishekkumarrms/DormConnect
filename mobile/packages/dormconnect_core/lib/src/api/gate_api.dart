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

  Future<List<LiveRequest>> getLiveRequests() async {
    final resp = await _client.get('/api/v1/gate/live-requests');
    final list = resp.data as List<dynamic>;
    return list.map((e) => LiveRequest.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<MovementLog>> getLiveOut() async {
    final resp = await _client.get('/api/v1/gate/live-out');
    final list = resp.data as List<dynamic>;
    return list.map((e) => MovementLog.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<MovementLog>> getHistory({int page = 1, int limit = 50}) async {
    final resp = await _client
        .get('/api/v1/gate/history', params: {'page': page, 'limit': limit});
    final list = resp.data as List<dynamic>;
    return list.map((e) => MovementLog.fromJson(e as Map<String, dynamic>)).toList();
  }
}
