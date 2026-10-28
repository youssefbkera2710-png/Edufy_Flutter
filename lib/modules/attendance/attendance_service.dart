import 'package:edufy/models/attendance/add_attendance.dart';
import 'package:edufy/models/attendance/attendance_list_model.dart';

import '../../core/config/app_endpoint.dart';
import '../../core/helpers/api_service.dart';

class AttendanceService {
  final ApiService apiService = ApiService();

  Future<AddAttendanceResponse?> addAttendance({
    required int classId,
    required int subjectId,
    required String date,
    required int sessionNumber,
    required List<Map<String, dynamic>> attendanceList,
  }) async {
    try {
      final Map<String, dynamic> bodyData = {
        "class_id": classId,
        "subject_id": subjectId,
        "date": date,
        "session_number": sessionNumber,
        "attendance": attendanceList,
      };

      final response = await apiService.post(
        url: AppEndpoints.addAttendance,
        data: bodyData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AddAttendanceResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Add Attendance Error: $e");
      return null;
    }
  }

  Future<AttendanceListResponse?> fetchAttendanceList({
    required int classId,
    required int subjectId,
    required String date,
    required int sessionNumber,
  }) async {
    try {
      final String fullUrl =
          "${AppEndpoints.getAttendance}/class/$classId/date/$date/session/$sessionNumber/subject/$subjectId";
      final response = await apiService.get(url: fullUrl);
      if (response.statusCode == 200) {
        return AttendanceListResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Fetch Attendance Error: $e");
      return null;
    }
  }
}
