import 'package:dio/dio.dart';
import 'package:edufy/core/config/app_endpoint.dart';
import 'package:edufy/core/helpers/api_service.dart';
import 'package:edufy/models/attendance_and_absence.dart';
import 'package:edufy/models/attendance_statistics.dart';
import 'package:edufy/models/exam.dart';
import 'package:edufy/models/grade.dart';
import 'package:edufy/models/homework_model.dart';
import 'package:edufy/models/user.dart';

class StudentService {
  ApiService apiService = ApiService();
  late Response response;
  Future<User?> getUserData() async {
    try {
      final response = await apiService.get(url: AppEndpoints.getUserData);

      if (response.statusCode == 200) {
        User user = User.fromMap(response.data['data']);
        return user;
      } else {
        print('getUserData failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('getUserData error: $e');
      return null;
    }
  }

  Future<AttendanceStatistics?> getAttendanceStatistics() async {
    try {
      response = await apiService.get(
        url: AppEndpoints.getAttendanceStatistics,
      );

      if (response.statusCode == 200) {
        AttendanceStatistics attendanceStatistics =
            AttendanceStatistics.fromMap(response.data['data']);
        return attendanceStatistics;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Grade?> getGrade() async {
    try {
      response = await apiService.get(url: "${AppEndpoints.getGrade}/summary");

      if (response.statusCode == 200) {
        Grade grade = Grade.fromMap(response.data['data']);
        return grade;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Future<List<Exam>?> getFutureExam() async {
  //   try {
  //     response = await apiService.get(url: AppEndpoints.getFutureExams);
  //     if (response.statusCode == 200) {
  //       List<Exam> exam = List.generate(response.data['data'].length, (index) {
  //         return Exam.fromMap(response.data['data'][index]);
  //       });
  //       return exam;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  Future<List<Exam>?> getAllExamStudent() async {
    try {
      response = await apiService.get(url: '${AppEndpoints.getExamStudent}');
      print('rererer${response.statusCode}');
      if (response.statusCode == 200) {
        List<Exam> exam = List.generate(response.data['data'].length, (index) {
          return Exam.fromMap(response.data['data'][index]);
        });
        return exam;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<AttendanceAndAbsence?> getDailyAttendanceStudent({
    // required int studentId,
    String? status,
    String? from,
    String? to,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (status != null && status != 'all') query['status'] = status;
      if (from != null) query['from'] = from;
      if (to != null) query['to'] = to;
      response = await apiService.get(
        url: AppEndpoints.getDailyAttendanceStudent,
        query: query,
      );

      if (response.statusCode == 200) {
        return AttendanceAndAbsence.fromMap(response.data);
      }
      return null;
    } catch (e) {
      print('getDailyAttendance error: $e');
      return null;
    }
  }

  Future<List<HomeworkModel>?> getStudentHomeworks() async {
    try {
      final response = await apiService.get(
        url: AppEndpoints.getStudentHomeworks,
      );
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => HomeworkModel.fromMap(json)).toList();
      }
      return null;
    } catch (e) {
      print('Error in getStudentHomeworks: $e');
      return null;
    }
  }
}
