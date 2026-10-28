// lib/modules/teacher/grades/services/exam_grades_service.dart

import 'package:edufy/models/student_grade_model.dart';
import '../../../core/config/app_endpoint.dart';
import '../../../core/helpers/api_service.dart';

class ExamGradesService {
  final ApiService apiService = ApiService();

  Future<List<StudentGrade>?> getStudentsGrades({
    required int examId,
    required int classId,
  }) async {
    try {
      final response = await apiService.get(
        url: '${AppEndpoints.teacherExams}/$examId/class/$classId/students',
      );

      print('📡 getStudentsGrades response: ${response.statusCode}');
      print('📡 getStudentsGrades data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];

        if (data == null) {
          return [];
        }

        if (data is! List) {
          print('⚠️ data is not a List: ${data.runtimeType}');
          return [];
        }

        // ✅ معالجة البيانات قبل تحويلها
        return data.map((e) {
          // ✅ التأكد من أن score يتم تحويله بشكل صحيح
          if (e['score'] is String) {
            e['score'] = double.tryParse(e['score'] as String);
          }
          return StudentGrade.fromMap(e);
        }).toList();
      }
      return [];
    } catch (e) {
      print('❌ getStudentsGrades error: $e');
      return null;
    }
  }

  /// حفظ درجات الطلاب
  Future<bool> submitGrades({
    required int examId,
    required List<GradeSubmission> grades,
  }) async {
    try {
      final body = {
        'exam_id': examId,
        'grades': grades.map((e) => e.toMap()).toList(),
      };

      print('📡 submitGrades body: $body');

      final response = await apiService.post(
        url: '${AppEndpoints.teacherExams}/grades',
        data: body,
      );

      print('📡 submitGrades response: ${response.statusCode}');
      print('📡 submitGrades data: ${response.data}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('❌ submitGrades error: $e');
      return false;
    }
  }
}
