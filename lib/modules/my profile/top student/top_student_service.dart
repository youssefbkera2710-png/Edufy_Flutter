
import 'package:edufy/core/config/app_endpoint.dart';
import 'package:edufy/core/helpers/api_service.dart';
import 'package:edufy/models/top_student.dart';


class TopStudentService {
  final ApiService apiService = ApiService();

  Future<TopStudentsResponse?> getTopStudents({int page = 1}) async {
    try {
      final response = await apiService.get(
        url: AppEndpoints.outstandingStudents,
        query: {'page': page},
      );
      return TopStudentsResponse.fromJson(response.data);
    } catch (e) {
      print('TopStudentService - getTopStudents Error: $e');
      return TopStudentsResponse(
        data: [],
        pagination: PaginationMeta.empty(),
        message: 'حدث خطأ غير متوقع',
        status: 500,
      );
    }
  }

  Future<TopStudentResponse?> getTopStudentById({required int id}) async {
    try {
      final response = await apiService.get(
        url: '${AppEndpoints.outstandingStudents}/$id',
      );
      return TopStudentResponse.fromJson(response.data);
    } catch (e) {
      print('TopStudentService - getTopStudentById Error: $e');
      return TopStudentResponse(
        data: null,
        message: 'حدث خطأ غير متوقع',
        status: 500,
      );
    }
  }
}