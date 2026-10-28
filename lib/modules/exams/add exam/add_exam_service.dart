import 'package:dio/dio.dart';
import 'package:edufy/core/config/app_endpoint.dart';
import 'package:edufy/core/helpers/api_service.dart';
import 'package:edufy/models/content%20education/teacher_classes.dart';
import 'package:edufy/models/content%20education/teacher_subject.dart';

// ─── Response wrapper ─────────────────────────────────────────
class ExamResponse {
  final bool success;
  final int? status;
  final String? message;
  final Map<String, dynamic>? exam;

  ExamResponse({required this.success, this.status, this.message, this.exam});
}

// ─── Exam Assignment model ────────────────────────────────────
class ExamAssignment {
  final int? id;
  final int? classId;
  final String? className;
  final int? subjectId;
  final String? subjectName;
  final String? topic;

  ExamAssignment({
    this.id,
    this.classId,
    this.className,
    this.subjectId,
    this.subjectName,
    this.topic,
  });

  factory ExamAssignment.fromJson(Map<String, dynamic> json) {
    return ExamAssignment(
      id: json['id'],
      classId: json['class_id'],
      className: json['class_name'],
      subjectId: json['subject_id'],
      subjectName: json['subject_name'],
      topic: json['topic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_id': classId,
      'class_name': className,
      'subject_id': subjectId,
      'subject_name': subjectName,
      'topic': topic,
    };
  }
}

// ─── TeacherExam model ────────────────────────────────────────
class TeacherExam {
  final int? id;
  final String? title;
  final String? examDate;
  final int? maxScore;
  final String? description;
  final int? durationMinutes;
  final List<ExamAssignment>? assignments;

  TeacherExam({
    this.id,
    this.title,
    this.examDate,
    this.maxScore,
    this.description,
    this.durationMinutes,
    this.assignments,
  });

  factory TeacherExam.fromJson(Map<String, dynamic> json) {
    return TeacherExam(
      id: json['id'],
      title: json['title']?.toString(),
      examDate: json['exam_date']?.toString(),
      maxScore: json['max_score'] != null
          ? (json['max_score'] is int
                ? json['max_score']
                : double.tryParse(json['max_score'].toString())?.toInt())
          : null,
      description: json['description']?.toString(),
      durationMinutes: json['duration_minutes'],
      assignments: json['assignments'] != null
          ? List<ExamAssignment>.from(
              (json['assignments'] as List).map(
                (e) => ExamAssignment.fromJson(e),
              ),
            )
          : [],
    );
  }
}

// ─── Service ──────────────────────────────────────────────────
class AddExamService {
  final ApiService _apiService = ApiService();

  // ─── Create ───────────────────────────────────────────────
  Future<ExamResponse> createExam({
    required String title,
    required String examDate,
    required int maxScore,
    required String description,
    required List<Map<String, dynamic>> assignments,
    int? durationMinutes,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "title": title,
        "exam_date": examDate,
        "max_score": maxScore,
        "description": description,
        "assignments": assignments,
      };

      if (durationMinutes != null) {
        data["duration_minutes"] = durationMinutes;
      }

      final response = await _apiService.post(
        url: AppEndpoints.createExam,
        data: data,
      );

      final statusCode = response.statusCode ?? 0;
      return ExamResponse(
        success: statusCode == 200 || statusCode == 201,
        status: statusCode,
        message: response.data?['message']?.toString(),
        exam: response.data?['data'],
      );
    } on DioException catch (e) {
      return ExamResponse(
        success: false,
        status: e.response?.statusCode ?? 500,
        message: e.response?.data?['message'] ?? 'حدث خطأ غير متوقع',
      );
    } catch (e) {
      return ExamResponse(
        success: false,
        status: 500,
        message: 'حدث خطأ غير متوقع',
      );
    }
  }

  // ─── Update ───────────────────────────────────────────────
  Future<ExamResponse> updateExam({
    required int id,
    required String title,
    required String examDate,
    required int maxScore,
    required String description,
    required List<Map<String, dynamic>> assignments,
    int? durationMinutes,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "title": title,
        "exam_date": examDate,
        "max_score": maxScore,
        "description": description,
        "assignments": assignments,
      };

      if (durationMinutes != null) {
        data["duration_minutes"] = durationMinutes;
      }

      final response = await _apiService.post(
        url: '${AppEndpoints.createExam}/$id',
        data: data,
      );

      final statusCode = response.statusCode ?? 0;
      return ExamResponse(
        success: statusCode == 200 || statusCode == 201,
        status: statusCode,
        message: response.data?['message']?.toString(),
        exam: response.data?['data'],
      );
    } on DioException catch (e) {
      return ExamResponse(
        success: false,
        status: e.response?.statusCode ?? 500,
        message: e.response?.data?['message'] ?? 'حدث خطأ غير متوقع',
      );
    } catch (e) {
      return ExamResponse(
        success: false,
        status: 500,
        message: 'حدث خطأ غير متوقع',
      );
    }
  }

  // ─── Get by ID ────────────────────────────────────────────
  Future<TeacherExam?> getExamById(int id) async {
    try {
      final response = await _apiService.get(
        url: '${AppEndpoints.createExam}/$id',
      );
      final data = response.data['data'];
      if (data == null) return null;
      return TeacherExam.fromJson(data);
    } catch (e) {
      print('getExamById error: $e');
      return null;
    }
  }

  // ─── Classes by Subject ───────────────────────────────────
  Future<List<ClassModel>> getTeacherClassesBySubject(int subjectId) async {
    try {
      final response = await _apiService.get(
        url: '${AppEndpoints.getTeacherClasses}?subject_id=$subjectId',
      );
      return (response.data['data'] as List)
          .map((e) => ClassModel.fromJson(e))
          .toList();
    } catch (e) {
      print('getTeacherClassesBySubject error: $e');
      return [];
    }
  }

  // ─── All Classes ──────────────────────────────────────────
  Future<List<ClassModel>> getTeacherClasses() async {
    final response = await _apiService.get(url: AppEndpoints.getTeacherClasses);
    return (response.data['data'] as List)
        .map((e) => ClassModel.fromJson(e))
        .toList();
  }

  // ─── Subjects ─────────────────────────────────────────────
  Future<List<SubjectModel>> getTeacherSubjects() async {
    try {
      final response = await _apiService.get(
        url: AppEndpoints.getTeacherSubjects,
      );

      if (response.data == null || response.data['data'] == null) {
        return [];
      }
      final data = response.data['data'];
      if (data is! List) {
        return [];
      }
      return data.map((e) => SubjectModel.fromJson(e)).toList();
    } catch (e) {
      print('getTeacherSubjects error: $e');
      return [];
    }
  }
}
