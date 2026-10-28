import 'package:dio/dio.dart';
import 'package:edufy/core/config/app_endpoint.dart';
import 'package:edufy/core/helpers/api_service.dart';
import 'package:edufy/models/content%20education/teacher_classes.dart';
import 'package:edufy/models/content%20education/teacher_subject.dart';
import 'package:edufy/models/homework_model.dart';

class HomeworkResponse {
  final HomeworkModel? homework;
  final int? status;
  final String? message;

  HomeworkResponse({this.homework, this.status, this.message});

  factory HomeworkResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    int statusCode = 0;
    final statusValue = json["status"];
    if (statusValue is int) {
      statusCode = statusValue;
    } else if (statusValue is String) {
      statusCode = int.tryParse(statusValue) ?? 0;
    }

    return HomeworkResponse(
      homework: data != null ? HomeworkModel.fromMap(data) : null,
      message: json["message"]?.toString() ?? "",
      status: statusCode,
    );
  }
}

class AddHomeworkService {
  final ApiService _apiService = ApiService();

  Future<HomeworkResponse?> createHomework({
    required String title,
    String? description,
    required String dueDate,
    required int classId,
    required int subjectId,
    String? topic,
    List<String>? attachmentPaths,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'due_date': dueDate,
        'class_id': classId,
        'subject_id': subjectId,
        'topic': topic,
      });

      if (attachmentPaths != null && attachmentPaths.isNotEmpty) {
        for (int i = 0; i < attachmentPaths.length; i++) {
          final filePath = attachmentPaths[i];
          final multipartFile = await MultipartFile.fromFile(
            filePath,
            filename: 'file_$i.${filePath.split('.').last}',
          );
          formData.files.add(MapEntry('files[$i]', multipartFile));
        }
      }

      final Response<dynamic> response = await _apiService.post(
        url: AppEndpoints.createHomework,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      return HomeworkResponse.fromJson(response.data);
    } on DioException catch (e) {
      print("CreateHomework Error: ${e.response?.data}");
      return HomeworkResponse(
        homework: null,
        message: e.response?.data['message'] ?? "حدث خطأ غير متوقع",
        status: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      print("CreateHomework Error Server: $e");
      return HomeworkResponse(
        homework: null,
        message: "حدث خطأ غير متوقع",
        status: 500,
      );
    }
  }

  Future<HomeworkResponse?> updateHomework({
    required int id,
    required String title,
    String? description,
    required String dueDate,
    required int classId,
    required int subjectId,
    String? topic,
    List<String>? newAttachmentPaths,
    List<HomeworkAttachment>? existingAttachments,
  }) async {
    try {
      final Map<String, dynamic> formDataMap = {
        'title': title,
        'description': description ?? '',
        'due_date': dueDate,
        'class_id': classId,
        'subject_id': subjectId,
        'topic': topic ?? '',
      };
      if (existingAttachments != null && existingAttachments.isNotEmpty) {
        for (int i = 0; i < existingAttachments.length; i++) {
          final attachment = existingAttachments[i];
          final url = attachment.url ?? '';
          if (url.isNotEmpty) {
            formDataMap['old_files[$i]'] = url;
            print('   old_files[$i]: $url');
          }
        }
      }

      final formData = FormData.fromMap(formDataMap);

      // ✅ إضافة الملفات الجديدة
      if (newAttachmentPaths != null && newAttachmentPaths.isNotEmpty) {
        for (int i = 0; i < newAttachmentPaths.length; i++) {
          final filePath = newAttachmentPaths[i];
          final multipartFile = await MultipartFile.fromFile(
            filePath,
            filename: 'file_$i.${filePath.split('.').last}',
          );
          formData.files.add(MapEntry('new_files[$i]', multipartFile));
        }
      }

      print('📤 FormData map fields: ${formData.fields}');
      print('📤 Files count: ${formData.files.length}');

      final Response<dynamic> response = await _apiService.post(
        url: "${AppEndpoints.createHomework}/$id",
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      print('✅ Update response status: ${response.statusCode}');

      return HomeworkResponse.fromJson(response.data);
    } catch (e) {
      print("❌ UpdateHomework Error: $e");
      return HomeworkResponse(
        homework: null,
        message: "حدث خطأ غير متوقع: $e",
        status: 500,
      );
    }
  }

  Future<HomeworkModel?> getHomeworkById(int id) async {
    try {
      final response = await _apiService.get(
        url: "${AppEndpoints.createHomework}/$id",
      );

      final data = response.data["data"];
      print('📥 Homework data: $data');
      return HomeworkModel.fromMap(data);
    } catch (e) {
      print('Error getting homework: $e');
      return null;
    }
  }

  Future<List<ClassModel>> getTeacherClasses() async {
    final response = await _apiService.get(url: AppEndpoints.getTeacherClasses);

    return (response.data['data'] as List)
        .map((e) => ClassModel.fromJson(e))
        .toList();
  }

  Future<List<SubjectModel>> getTeacherSubjects() async {
    final response = await _apiService.get(
      url: AppEndpoints.getTeacherSubjects,
    );

    return (response.data['data'] as List)
        .map((e) => SubjectModel.fromJson(e))
        .toList();
  }
}
