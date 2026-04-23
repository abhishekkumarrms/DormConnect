import 'api_client.dart';
import '../models/mess.dart';

class MessApi {
  final ApiClient _client;
  MessApi(this._client);

  Future<List<MessMenu>> getMenu(String hostelId) async {
    final resp = await _client.get('/api/v1/mess/menu', params: {'hostel_id': hostelId});
    return (resp.data as List<dynamic>)
        .map((e) => MessMenu.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MessOff> applyMessOff(Map<String, dynamic> data) async {
    final resp = await _client.post('/api/v1/mess/mess-off', data: data);
    return MessOff.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<MessOff>> getMyMessOffs() async {
    final resp = await _client.get('/api/v1/mess/mess-off/my');
    return (resp.data as List<dynamic>)
        .map((e) => MessOff.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> getCount(
      String hostelId, String date, String mealType) async {
    final resp = await _client.get('/api/v1/mess/count', params: {
      'hostel_id': hostelId,
      'date': date,
      'meal_type': mealType,
    });
    return resp.data as Map<String, dynamic>;
  }
}
