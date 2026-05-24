import 'api_client.dart';
import '../models/leave.dart';

class LeaveApi {
  final ApiClient _client;
  LeaveApi(this._client);

  Future<LeaveApplication> apply(Map<String, dynamic> data) async {
    final resp = await _client.post('/api/v1/leaves', data: data);
    return LeaveApplication.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<LeaveApplication>> list({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final resp = await _client.get('/api/v1/leaves', params: {
      if (status != null) 'status': status,
      'page': page,
      'limit': limit,
    });
    final list = resp.data as List<dynamic>;
    return list
        .map((e) => LeaveApplication.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<LeaveApplication> getById(String id) async {
    final resp = await _client.get('/api/v1/leaves/$id');
    return LeaveApplication.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<LeaveApplication> action(
      String id, String action, Map<String, dynamic> data) async {
    final resp =
        await _client.post('/api/v1/leaves/$id/$action', data: data);
    return LeaveApplication.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<LeaveApplication> guardianConfirm(String token) async {
    final resp = await _client
        .post('/api/v1/leaves/guardian-confirm', data: {'token': token});
    return LeaveApplication.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<void> guardianConfirmAuthenticated(
    String leaveId, {
    required bool confirmed,
    String? note,
  }) async {
    await _client.post(
      '/api/v1/leaves/$leaveId/guardian-confirm',
      data: {'confirmed': confirmed, if (note != null && note.isNotEmpty) 'note': note},
    );
  }

  Future<List<Map<String, dynamic>>> getCalendar(
      String hostelId, String month) async {
    final resp = await _client.get('/api/v1/leaves/calendar',
        params: {'hostel_id': hostelId, 'month': month});
    return (resp.data as List<dynamic>)
        .cast<Map<String, dynamic>>();
  }
}
