import 'api_client.dart';
import '../models/sos.dart';

class SosApi {
  final ApiClient _client;
  SosApi(this._client);

  Future<SosAlert> trigger({String? message, String? location}) async {
    final resp = await _client.post('/api/v1/sos', data: {
      if (message != null) 'message': message,
      if (location != null) 'location': location,
    });
    return SosAlert.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<SosAlert>> getHistory({int page = 1, int limit = 20}) async {
    final resp = await _client.get('/api/v1/sos/history',
        params: {'page': page, 'limit': limit});
    return (resp.data as List<dynamic>)
        .map((e) => SosAlert.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<SosAlert> respond(String id, String note) async {
    final resp = await _client
        .post('/api/v1/sos/$id/respond', data: {'note': note});
    return SosAlert.fromJson(resp.data as Map<String, dynamic>);
  }
}
