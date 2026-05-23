import 'api_client.dart';
import '../models/visitor.dart';

class VisitorApi {
  final ApiClient _client;
  VisitorApi(this._client);

  Future<Visitor> request(Map<String, dynamic> data) async {
    final resp = await _client.post('/api/v1/visitors', data: data);
    return Visitor.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<Visitor>> list({String? status}) async {
    final resp = await _client.get('/api/v1/visitors',
        params: {if (status != null) 'status': status});
    return (resp.data as List<dynamic>)
        .map((e) => Visitor.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Visitor> approve(String id) async {
    final resp = await _client.post('/api/v1/visitors/$id/approve');
    return Visitor.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<Visitor> reject(String id, {String? reason}) async {
    final resp = await _client.post('/api/v1/visitors/$id/reject',
        data: {if (reason != null) 'reason': reason});
    return Visitor.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<Visitor> guardEntry(String id) async {
    final resp = await _client.post('/api/v1/visitors/$id/guard-entry');
    return Visitor.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<Visitor> guardExit(String id) async {
    final resp = await _client.post('/api/v1/visitors/$id/guard-exit');
    return Visitor.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<Visitor>> getActive() async {
    final resp = await _client.get('/api/v1/visitors/active');
    return (resp.data as List<dynamic>)
        .map((e) => Visitor.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
