import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/maintenance.dart';

class MaintenanceApi {
  final ApiClient _client;
  MaintenanceApi(this._client);

  Future<MaintenanceRequest> create(Map<String, dynamic> data) async {
    final resp = await _client.post('/api/v1/maintenance', data: data);
    return MaintenanceRequest.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<MaintenanceRequest> createWithPhoto(FormData formData) async {
    final resp = await _client.postMultipart('/api/v1/maintenance', formData);
    return MaintenanceRequest.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<MaintenanceRequest> getById(String id) async {
    final resp = await _client.get('/api/v1/maintenance/$id');
    return MaintenanceRequest.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<MaintenanceRequest>> list({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final resp = await _client.get('/api/v1/maintenance', params: {
      if (status != null) 'status': status,
      'page': page,
      'limit': limit,
    });
    return (resp.data as List<dynamic>)
        .map((e) => MaintenanceRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MaintenanceRequest> action(
      String id, String action, Map<String, dynamic> data) async {
    final resp =
        await _client.post('/api/v1/maintenance/$id/$action', data: data);
    return MaintenanceRequest.fromJson(resp.data as Map<String, dynamic>);
  }
}
