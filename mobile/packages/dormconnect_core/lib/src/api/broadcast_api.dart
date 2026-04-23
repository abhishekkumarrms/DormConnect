import 'api_client.dart';
import '../models/broadcast.dart';

class BroadcastApi {
  final ApiClient _client;
  BroadcastApi(this._client);

  Future<List<Broadcast>> list({int page = 1, int limit = 20}) async {
    final resp = await _client.get('/api/v1/comms/broadcasts',
        params: {'page': page, 'limit': limit});
    return (resp.data as List<dynamic>)
        .map((e) => Broadcast.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Notice>> getNotices(String hostelId) async {
    final resp = await _client.get('/api/v1/comms/notices',
        params: {'hostel_id': hostelId});
    return (resp.data as List<dynamic>)
        .map((e) => Notice.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
