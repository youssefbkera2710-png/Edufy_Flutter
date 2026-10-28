import 'package:edufy/core/config/app_endpoint.dart';
import 'package:edufy/core/helpers/api_service.dart';
import 'package:edufy/models/teacher_exam.dart';
import 'package:edufy/models/homework_model.dart';
import 'package:edufy/models/teacher_statistics.dart';

class TeacherService {
  Future<TeacherExam?> getTeacherExams({int page = 1, int limit = 15}) async {
    ApiService apiService = ApiService();
    try {
      final response = await apiService.get(
        url: '${AppEndpoints.getTeacherExams}?page=$page&limit=$limit',
      );
      if (response.statusCode == 200) return TeacherExam.fromMap(response.data);
      return null;
    } catch (e) {
      print('getTeacherExams error: $e');
      return null;
    }
  }

  Future<TeacherHomeworkPaginated?> getTeacherHomework({
    int page = 1,
    int limit = 15,
  }) async {
    ApiService apiService = ApiService();
    try {
      final response = await apiService.get(
        url: '${AppEndpoints.getTeacherHomework}?page=$page&limit=$limit',
      );
      if (response.statusCode == 200) {
        return TeacherHomeworkPaginated.fromMap(response.data);
      }
      return null;
    } catch (e) {
      print('getTeacherHomework error: $e');
      return null;
    }
  }

  Future<bool> deleteExam(int id) async {
    ApiService apiService = ApiService();
    try {
      final response = await apiService.delete(
        url: '${AppEndpoints.deleteExam}/$id',
      );
      return response.statusCode == 200;
    } catch (e) {
      print('deleteExam error: $e');
      return false;
    }
  }

  Future<bool> deleteHomework(int id) async {
    ApiService apiService = ApiService();
    try {
      final response = await apiService.delete(
        url: '${AppEndpoints.deleteHomewrok}/$id',
      );
      return response.statusCode == 200;
    } catch (e) {
      print('deleteHomework error: $e');
      return false;
    }
  }

  Future<TeacherStatistics?> getTeacherStatistics() async {
    final apiService = ApiService();
    try {
      final response = await apiService.get(
        url: AppEndpoints.getTeacherStatistics,
      );
      if (response.statusCode == 200) {
        return TeacherStatistics.fromMap(response.data);
      }
      return null;
    } catch (e) {
      print('getTeacherStatistics error: $e');
      return null;
    }
  }
}

class TeacherHomeworkPaginated {
  final List<HomeworkModel> data;
  final HwPagination? pagination;

  TeacherHomeworkPaginated({required this.data, this.pagination});

  factory TeacherHomeworkPaginated.fromMap(Map<String, dynamic> json) {
    final List rawData = json['data'] ?? [];
    return TeacherHomeworkPaginated(
      data: rawData.map((e) => HomeworkModel.fromMap(e)).toList(),
      pagination: json['pagination'] != null
          ? HwPagination.fromMap(json['pagination'])
          : null,
    );
  }
}

class HwPagination {
  final int currentPage;
  final bool hasMorePages;

  HwPagination({required this.currentPage, required this.hasMorePages});

  factory HwPagination.fromMap(Map<String, dynamic> json) => HwPagination(
    currentPage: json['current_page'] ?? 1,
    hasMorePages: json['has_more_pages'] ?? false,
  );
}
