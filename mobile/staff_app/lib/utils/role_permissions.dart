import 'package:dormconnect_core/dormconnect_core.dart';

class RolePermissions {
  static bool canManageEnrollment(UserRole r) => r == UserRole.caretaker;
  static bool canEditStudentProfile(UserRole r) => r == UserRole.caretaker;
  static bool canActOnComplaints(UserRole r) =>
      r == UserRole.caretaker || r == UserRole.asstWarden;
  static bool canViewComplaints(UserRole r) => true;
  static bool canApproveLeave(UserRole r) => r.isStaff;
  static bool canActOnLeaves(UserRole r) =>
      r == UserRole.caretaker || r == UserRole.warden || r == UserRole.asstWarden;
  static bool canBroadcastToHostel(UserRole r) => r.isStaff;
  static bool canBroadcastToAll(UserRole r) =>
      r == UserRole.asstChiefWarden || r == UserRole.chiefWarden;
  static bool canViewAllHostels(UserRole r) =>
      r == UserRole.asstChiefWarden || r == UserRole.chiefWarden;
  static bool canManageStaff(UserRole r) => r == UserRole.chiefWarden;
  static bool canViewAnalytics(UserRole r) =>
      r == UserRole.warden ||
      r == UserRole.asstWarden ||
      r == UserRole.asstChiefWarden ||
      r == UserRole.chiefWarden;
  static bool canManageShifts(UserRole r) =>
      r == UserRole.caretaker ||
      r == UserRole.asstChiefWarden ||
      r == UserRole.chiefWarden;
  static bool canManageVisitors(UserRole r) => r == UserRole.caretaker;
  static bool canManageMess(UserRole r) => r == UserRole.caretaker;
  static bool showGateMonitor(UserRole r) => true;
  static bool canManageMaintenance(UserRole r) =>
      r == UserRole.caretaker || r == UserRole.asstWarden;
  static bool showStudentsTab(UserRole r) => r.isStaff;
  static bool showMessTab(UserRole r) => r == UserRole.caretaker;
  static bool showVisitorsTab(UserRole r) => r == UserRole.caretaker;
  static bool showAnalyticsTab(UserRole r) => canViewAnalytics(r);
  static bool showStaffMgmtTab(UserRole r) => r == UserRole.chiefWarden;
  static bool showShiftsTab(UserRole r) => r == UserRole.caretaker;
}
