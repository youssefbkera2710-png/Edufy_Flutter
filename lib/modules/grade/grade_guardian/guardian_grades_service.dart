// guardian_grades_service.dart
import 'package:edufy/core/config/app_endpoint.dart';
import 'package:edufy/core/helpers/api_service.dart';
import 'package:edufy/models/grade_guardian.dart';

/// Response Model خاص بـ Guardian
class GuardianGradesResponse {
  final List<SubjectExam> grades;
  final double? average;
  final dynamic rank;
  final int? status;
  final String? message;

  GuardianGradesResponse({
    required this.grades,
    this.average,
    this.rank,
    this.status,
    this.message,
  });

  factory GuardianGradesResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? {};

    // استخراج grades من data
    List<SubjectExam> exams = [];
    if (data["grades"] is List) {
      exams = (data["grades"] as List)
          .map((x) => SubjectExam.fromMap(x))
          .toList();
    } else if (json["data"] is List) {
      // في حال كان data مصفوفة مباشرة
      exams = (json["data"] as List)
          .map((x) => SubjectExam.fromMap(x))
          .toList();
    }

    return GuardianGradesResponse(
      grades: exams,
      average:
          (data["average"] as num?)?.toDouble() ??
          (data["overall_average"] as num?)?.toDouble(),
      rank: data["rank"] ?? data["rank"],
      status: json["status"],
      message: json["message"],
    );
  }
}

/// Service خاص بدرجات الابن
class GuardianGradesService {
  final ApiService apiService = ApiService();

  /// جلب جميع درجات الابن
  Future<GuardianGradesResponse> getChildGrades(int childId) async {
    try {
      final response = await apiService.get(
        url: AppEndpoints.getChildGrades(childId),
      );
      return GuardianGradesResponse.fromJson(response.data);
    } catch (e) {
      print('getChildGrades error: $e');
      return GuardianGradesResponse(
        grades: [],
        status: 500,
        message: "حدث خطأ غير متوقع",
      );
    }
  }

  /// جلب درجات الابن لمادة محددة
  Future<GuardianGradesResponse> getChildSubjectGrades(
    int childId,
    int subjectId,
  ) async {
    try {
      final response = await apiService.get(
        url: AppEndpoints.getChildSubjectGrades(childId, subjectId),
      );
      return GuardianGradesResponse.fromJson(response.data);
    } catch (e) {
      print('getChildSubjectGrades error: $e');
      return GuardianGradesResponse(
        grades: [],
        status: 500,
        message: "حدث خطأ غير متوقع",
      );
    }
  }
}
