class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );
  static const String apiPrefix = '/api/v1';

  // Auth
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String staffLogin = '/auth/staff-login';
  static const String guardLogin = '/auth/guard-login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Student
  static const String enrollStudent = '/students/enroll';
  static const String myProfile = '/students/me';
  static const String pendingEnrollments = '/students/pending-enrollments';
  static const String hostelStudents = '/students/hostel';

  // Gate
  static const String generateGateOtp = '/gate/otp/generate';
  static const String gateOtpStatus = '/gate/otp/status';
  static const String myMovements = '/gate/history';
  static const String liveOut = '/gate/live-out';
  static const String liveRequests = '/gate/live-requests';
  static const String guardConfirm = '/gate/confirm';
  static const String manualEntry = '/gate/manual-entry';

  // Leave
  static const String myLeaves = '/leaves/mine';
  static const String applyLeave = '/leaves';
  static const String leaves = '/leaves';

  // Complaints
  static const String myComplaints = '/complaints/mine';
  static const String complaints = '/complaints';

  // Maintenance
  static const String myMaintenance = '/maintenance/mine';
  static const String maintenance = '/maintenance';

  // Communications
  static const String broadcasts = '/comms/broadcasts';
  static const String broadcastsSend = '/comms/broadcasts';
  static const String notices = '/comms/notices';
  static const String noticesManage = '/comms/notices';

  // SOS
  static const String triggerSos = '/sos/trigger';

  // Mess
  static const String messMenu = '/mess/menu';
  static const String applyMessOff = '/mess/mess-off';
  static const String mess = '/mess';

  // Visitors
  static const String requestVisitor = '/visitors';
  static const String visitors = '/visitors';

  // Shifts / Analytics
  static const String shifts = '/shifts';
  static const String analytics = '/analytics';

  // User
  static const String updateFcmToken = '/users/fcm-token';
}
