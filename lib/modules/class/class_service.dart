/// service => class_history_service.dart

import 'package:edufy/core/config/app_endpoint.dart';
import 'package:edufy/core/helpers/api_service.dart';
import 'package:edufy/models/class.dart';

class ClassService {
  final ApiService apiService = ApiService();

  Future<ClassHistoryResponse?> getClassHistory() async {
    try {
      final response = await apiService.get(url: AppEndpoints.getClass);

      return ClassHistoryResponse.fromJson(response.data);
    } catch (e) {
      print(e);

      return ClassHistoryResponse(
        data: [],
        status: 500,
        message: "حدث خطأ غير متوقع",
      );
    }
  }

  Future<ClassHistoryResponse?> getGuardianClassHistory(int studentId) async {
    try {
      final url = '${AppEndpoints.getGuardianClass}/$studentId/class-history';
      final response = await apiService.get(url: url);
      return ClassHistoryResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return ClassHistoryResponse(
        data: [],
        status: 500,
        message: "حدث خطأ غير متوقع",
      );
    }
  }
}
