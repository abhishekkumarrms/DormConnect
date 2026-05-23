import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../api/auth_api.dart';
import '../api/student_api.dart';
import '../api/gate_api.dart';
import '../api/leave_api.dart';
import '../api/complaint_api.dart';
import '../api/maintenance_api.dart';
import '../api/mess_api.dart';
import '../api/visitor_api.dart';
import '../api/broadcast_api.dart';
import '../api/sos_api.dart';
import '../api/analytics_api.dart';

final authApiProvider = Provider<AuthApi>(
    (ref) => AuthApi(ref.watch(apiClientProvider)));

final studentApiProvider = Provider<StudentApi>(
    (ref) => StudentApi(ref.watch(apiClientProvider)));

final gateApiProvider = Provider<GateApi>(
    (ref) => GateApi(ref.watch(apiClientProvider)));

final leaveApiProvider = Provider<LeaveApi>(
    (ref) => LeaveApi(ref.watch(apiClientProvider)));

final complaintApiProvider = Provider<ComplaintApi>(
    (ref) => ComplaintApi(ref.watch(apiClientProvider)));

final maintenanceApiProvider = Provider<MaintenanceApi>(
    (ref) => MaintenanceApi(ref.watch(apiClientProvider)));

final messApiProvider = Provider<MessApi>(
    (ref) => MessApi(ref.watch(apiClientProvider)));

final visitorApiProvider = Provider<VisitorApi>(
    (ref) => VisitorApi(ref.watch(apiClientProvider)));

final broadcastApiProvider = Provider<BroadcastApi>(
    (ref) => BroadcastApi(ref.watch(apiClientProvider)));

final sosApiProvider = Provider<SosApi>(
    (ref) => SosApi(ref.watch(apiClientProvider)));

final analyticsApiProvider = Provider<AnalyticsApi>(
    (ref) => AnalyticsApi(ref.watch(apiClientProvider)));
