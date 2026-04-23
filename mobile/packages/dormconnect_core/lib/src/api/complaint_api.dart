import 'api_client.dart';
import '../models/complaint.dart';

class ComplaintApi {
  final ApiClient _client;
  ComplaintApi(this._client);

  Future<Complaint> create(Map<String, dynamic> data) async {
    final resp = await _client.post('/api/v1/complaints', data: data);
    return Complaint.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<Complaint>> list({
    String? status,
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    final resp = await _client.get('/api/v1/complaints', params: {
      if (status != null) 'status': status,
      if (category != null) 'category': category,
      'page': page,
      'limit': limit,
    });
    return (resp.data as List<dynamic>)
        .map((e) => Complaint.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Complaint> getById(String id) async {
    final resp = await _client.get('/api/v1/complaints/$id');
    return Complaint.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<Complaint> action(String id, String action, Map<String, dynamic> data) async {
    final resp = await _client.post('/api/v1/complaints/$id/$action', data: data);
    return Complaint.fromJson(resp.data as Map<String, dynamic>);
  }
}
