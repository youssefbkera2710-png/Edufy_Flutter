
import 'package:edufy/core/config/user_info.dart';
import 'package:edufy/models/schedule/schedule_model.dart';
import '../../../core/config/app_endpoint.dart';
import '../../../core/helpers/api_service.dart';

class MyScheduleService {
  final ApiService apiService = ApiService();

  Future<ScheduleModel?> getSchedule({int? studentId}) async {
    try {
      String url = AppEndpoints.getSchedule;

      if (UserInfo.role == 'guardian' && studentId != null) {
        url = AppEndpoints.getGuardianSchedule(studentId);
      }
      else if (UserInfo.role == 'teacher') {
        url = AppEndpoints.getTeacherSchedule;
      }

      final response = await apiService.get(url: url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ScheduleModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Schedule Service Error: $e");
      return null;
    }
  }
}