import 'api_client.dart';
import '../models/analytics.dart';

class AnalyticsApi {
  final ApiClient _client;
  AnalyticsApi(this._client);

  Future<InstitutionOverview> getOverview(String institutionId) async {
    final resp = await _client.get('/api/v1/analytics/overview',
        params: {'institution_id': institutionId});
    return InstitutionOverview.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<HostelHealth> getHostelHealth(String hostelId) async {
    final resp = await _client.get('/api/v1/analytics/hostel-health/$hostelId');
    return HostelHealth.fromJson(resp.data as Map<String, dynamic>);
  }
}
