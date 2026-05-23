import 'api_client.dart';
import '../models/student.dart';

class StudentApi {
  final ApiClient _client;
  StudentApi(this._client);

  Future<Student> getProfile() async {
    final resp = await _client.get('/api/v1/students/me');
    return Student.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<Student>> list({
    String? hostelId,
    String? enrollmentStatus,
    int page = 1,
    int limit = 50,
  }) async {
    final resp = await _client.get('/api/v1/students', params: {
      if (hostelId != null) 'hostel_id': hostelId,
      if (enrollmentStatus != null) 'enrollment_status': enrollmentStatus,
      'page': page,
      'limit': limit,
    });
    return (resp.data as List<dynamic>)
        .map((e) => Student.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> enroll(Map<String, dynamic> data) async {
    final resp = await _client.post('/api/v1/students/enroll', data: data);
    return resp.data as Map<String, dynamic>;
  }

  Future<Student> getById(String id) async {
    final resp = await _client.get('/api/v1/students/$id');
    return Student.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<Student> approve(String id) async {
    final resp = await _client.post('/api/v1/students/$id/approve');
    return Student.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<Student> reject(String id, {String? reason}) async {
    final resp = await _client.post('/api/v1/students/$id/reject',
        data: {if (reason != null) 'reason': reason});
    return Student.fromJson(resp.data as Map<String, dynamic>);
  }
}
