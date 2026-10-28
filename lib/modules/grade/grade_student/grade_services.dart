
import 'package:edufy/core/config/app_endpoint.dart';
import 'package:edufy/core/helpers/api_service.dart';
import 'package:edufy/models/grade.dart';

class GradesResponse {
  final Grade? grade;

  final int? status;

  final String? message;

  GradesResponse({this.grade, this.status, this.message});

  factory GradesResponse.fromJson(Map<String, dynamic> json) {
    return GradesResponse(
      grade: json["data"] != null ? Grade.fromMap(json["data"]) : null,

      status: json["status"],

      message: json["message"],
    );
  }
}

class GradesService {
  final ApiService apiService = ApiService();

  /// summary
  Future<GradesResponse?> getGradesSummary() async {
    try {
      final response = await apiService.get(
        url: "${AppEndpoints.getGrade}/summary",
      );

      return GradesResponse.fromJson(response.data);
    } catch (e) {
      print(e);

      return GradesResponse(
        grade: null,
        status: 500,
        message: "حدث خطأ غير متوقع",
      );
    }
  }

  /// all exams
  Future<List<SubjectExam>> getAllExams() async {
    try {
      final response = await apiService.get(url: AppEndpoints.getGrade);

      final data = response.data["data"];

      return List<SubjectExam>.from(data.map((x) => SubjectExam.fromMap(x)));
    } catch (e) {
      print(e);

      return [];
    }
  }
}
