import 'package:dio/dio.dart';
import 'package:edufy/core/config/app_endpoint.dart';
import 'package:edufy/core/helpers/api_service.dart';
import 'package:edufy/models/absence.dart';
import 'package:edufy/models/attendance_and_absence.dart';
import 'package:edufy/models/behaviors.dart';
import 'package:edufy/models/children.dart';
import 'package:edufy/models/exam.dart';
import 'package:edufy/models/expenses.dart';
import 'package:edufy/models/homework_model.dart';
import 'package:edufy/models/invoice.dart';
import 'package:edufy/models/payment_history.dart';

class GuardianService {
  ApiService apiService = ApiService();
  late Response response;

  Future<List<Children>?> getAllChildren() async {
    try {
      response = await apiService.get(url: AppEndpoints.getAllChildren);
      if (response.statusCode == 200) {
        return List.generate(
          response.data['data'].length,
          (i) => Children.fromMap(response.data['data'][i]),
        );
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<PaymentHistory>?> getPaymentHistory() async {
    try {
      response = await apiService.get(url: AppEndpoints.getPaymentHistory);
      if (response.statusCode == 200) {
        return List.generate(
          response.data['data'].length,
          (i) => PaymentHistory.fromMap(response.data['data'][i]),
        );
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Expenses?> getExpenses() async {
    try {
      response = await apiService.get(url: AppEndpoints.getExpenses);
      if (response.statusCode == 200) {
        return Expenses.fromMap(response.data['data']);
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Invoice>?> getInvoice({required String studentName}) async {
    try {
      response = await apiService.get(
        url: AppEndpoints.getInvoice,
        query: {'student_name': studentName},
      );
      if (response.statusCode == 200) {
        return List.generate(
          response.data['data'].length,
          (i) => Invoice.fromMap(response.data['data'][i]),
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Absence>?> getAbsence({required String studentName}) async {
    try {
      response = await apiService.get(
        url: AppEndpoints.getAbsence,
        query: {'student_name': studentName},
      );
      if (response.statusCode == 200) {
        List<Absence> absence = List.generate(
          response.data['data'].length,
          (index) => Absence.fromMap(response.data['data'][index]),
        );
        return absence;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> submitAbsenceRequest({
    required String studentId,
    required String absenceDate,
    required String reason,
    String? attachmentPath,
  }) async {
    try {
      final map = <String, dynamic>{
        'student_id': int.tryParse(studentId) ?? studentId,
        'absence_date': absenceDate,
        'reason': reason,
      };

      if (attachmentPath != null) {
        map['attachment'] = await MultipartFile.fromFile(
          attachmentPath,
          filename: attachmentPath.split('/').last,
        );
      }

      final formData = FormData.fromMap(map);

      response = await apiService.post(
        url: AppEndpoints.submitAbsenceRequest,
        data: formData,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Exam>?> getAllExam({required int id}) async {
    try {
      response = await apiService.get(
        url: '${AppEndpoints.getAllExam}$id/exams',
      );
      if (response.statusCode == 200) {
        return List.generate(
          response.data['data'].length,
          (i) => Exam.fromMap(response.data['data'][i]),
        );
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<AttendanceAndAbsence?> getDailyAttendance({
    required int studentId,
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
        url: '${AppEndpoints.getDailyAttendance}$studentId/daily-attendance',
        query: query,
      );
      print("RAW JSON DATA: ${response.data}");
      if (response.statusCode == 200) {
        return AttendanceAndAbsence.fromMap(response.data);
      }
      return null;
    } catch (e) {
      print('getDailyAttendance error: $e');
      return null;
    }
  }

  Future<List<HomeworkModel>?> getChildHomeworks({required int childId}) async {
    try {
      final response = await apiService.get(
        url: '${AppEndpoints.getChildHomeworksBase}/$childId/homeworks',
      );
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => HomeworkModel.fromMap(json)).toList();
      }
      return null;
    } catch (e) {
      print('Error in getChildHomeworks: $e');
      return null;
    }
  }

  Future<List<Behaviors>?> getBehaviors({String? studentName}) async {
    try {
      response = await apiService.get(
        url: AppEndpoints.getBehaviors,
        query: studentName != null ? {'student_name': studentName} : null,
      );
      if (response.statusCode == 200) {
        return List.generate(
          response.data['data'].length,
          (i) => Behaviors.fromMap(response.data['data'][i]),
        );
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
