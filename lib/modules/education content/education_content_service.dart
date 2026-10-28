import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:edufy/core/config/user_info.dart';
import '../../core/config/app_endpoint.dart';
import '../../core/helpers/api_service.dart';
import '../../models/content education/add_educational_content.dart';
import '../../models/content education/educational_content.dart';
import '../../models/content education/educational_content_details.dart';
import '../../models/content education/teacher_classes.dart';
import '../../models/content education/teacher_subject.dart';

class EducationalContentService {
  final ApiService apiService = ApiService();

  Future<EducationalContentModel?> getAllContent({
    int? childId,
    int page = 1,
  }) async {
    try {
      String url;
      Map<String, dynamic> queryParameters = {'per_page': 15, 'page': page};

      if (UserInfo.role == 'guardian') {
        url = AppEndpoints.getAllEducationalContentForGuardian;
        if (childId != null) {
          queryParameters["student_id"] = childId;
        }
      } else if (UserInfo.role == 'student') {
        url = AppEndpoints.getAllEducationalContentForStudent;
      } else {
        url = AppEndpoints.getAllEducationalContentForTeacher;
      }

      final response = await apiService.get(url: url, query: queryParameters);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return EducationalContentModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Get All Content Error: $e");
      return null;
    }
  }

  Future<EducationalContentDetails?> getContentDetails(
    int id, {
    int? childId,
  }) async {
    try {
      String url;

      if (UserInfo.role == 'guardian') {
        url = AppEndpoints.guardianEducationalContentDetails(id);
      } else if (UserInfo.role == 'student') {
        url = "${AppEndpoints.educationalContentDetailsForStudent}/$id";
      } else {
        url = "${AppEndpoints.educationalContentDetailsForTeacher}/$id";
      }

      final response = await apiService.get(url: url);

      if (response.statusCode == 200) {
        return EducationalContentDetails.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<AddEducationalContentModel?> addEducationalContent({
    required String title,
    required String body,
    required String topic,
    required int subjectId,
    required List<int> classesIds,
    required bool allowComments,
    required List<File> selectedFiles,
  }) async {
    try {
      final url = AppEndpoints.getAllEducationalContentForTeacher;

      final Map<String, dynamic> formDataMap = {
        "title": title,
        "body": body,
        "topic": topic,
        "subject_id": subjectId.toString(),
        "allow_comments": allowComments ? "1" : "0",
      };

      for (int i = 0; i < classesIds.length; i++) {
        formDataMap["classes_ids[$i]"] = classesIds[i].toString();
      }

      final dio.FormData formData = dio.FormData.fromMap(formDataMap);

      for (int i = 0; i < selectedFiles.length; i++) {
        formData.files.add(
          MapEntry(
            "files[]",
            await dio.MultipartFile.fromFile(
              selectedFiles[i].path,
              filename: selectedFiles[i].path.split('/').last,
            ),
          ),
        );
      }

      final response = await apiService.post(url: url, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AddEducationalContentModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      if (e is dio.DioException) {
        print("خطأ الـ Dio في الإضافة: ${e.message}");
        print("بيانات الاستجابة من السيرفر: ${e.response?.data}");
      } else {
        print("خطأ غير متوقع في الإضافة: $e");
      }
      return null;
    }
  }

  Future<dynamic> deleteEducationalContent(int contentId) async {
    final response = await apiService.delete(
      url: "${AppEndpoints.educationalContentDetailsForTeacher}/$contentId",
    );
    return response.data;
  }

  Future<dynamic> updateEducationalContent({
    required int id,
    required String title,
    required String body,
    required String topic,
    required int subjectId,
    required List<int> classesIds,
    required bool allowComments,
    required List<String> oldFilesUrls,
    required List<File> newFiles,
  }) async {
    try {
      Map<String, dynamic> data = {
        "title": title,
        "body": body,
        "topic": topic,
        "subject_id": subjectId.toString(),
        "allow_comments": allowComments ? "1" : "0",
      };

      for (int i = 0; i < classesIds.length; i++) {
        data["classes_ids[$i]"] = classesIds[i].toString();
      }

      for (int i = 0; i < oldFilesUrls.length; i++) {
        data["old_files[$i]"] = oldFilesUrls[i];
      }

      final formData = dio.FormData.fromMap(data);

      for (int i = 0; i < newFiles.length; i++) {
        formData.files.add(
          MapEntry(
            "new_files[]",
            await dio.MultipartFile.fromFile(
              newFiles[i].path,
              filename: newFiles[i].path.split('/').last,
            ),
          ),
        );
      }

      final response = await apiService.post(
        url: "${AppEndpoints.updateEducationalContent}/$id",
        data: formData,
      );

      return response.data;
    } catch (e) {
      if (e is dio.DioException) {
        print("Dio Error during update: ${e.response?.data}");
      } else {
        print("خطأ أثناء التعديل: $e");
      }
      return null;
    }
  }

  Future<TeacherSubjectsResponse?> getSubjects() async {
    try {
      final response = await apiService.get(
        url: AppEndpoints.getTeacherSubjects,
      );
      if (response.statusCode == 200 && response.data != null) {
        return TeacherSubjectsResponse.fromJson(response.data);
      }
    } catch (e) {
      print("Error fetching subjects: $e");
    }
    return null;
  }

  Future<TeacherClassesResponse?> getClasses() async {
    try {
      final response = await apiService.get(
        url: AppEndpoints.getTeacherClasses,
      );
      if (response.statusCode == 200 && response.data != null) {
        return TeacherClassesResponse.fromJson(response.data);
      }
    } catch (e) {
      print("Error fetching classes: $e");
    }
    return null;
  }
}
