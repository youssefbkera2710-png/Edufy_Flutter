import '../../../core/config/app_endpoint.dart';
import '../../../core/helpers/api_service.dart';

class changeRespons {
  final int? status;
  final String? message;

  changeRespons({this.message, this.status});

  factory changeRespons.fromJson(Map<String, dynamic> json) {
    return changeRespons(
      message: json["message"] ?? "",
      status: json["status"] ?? 0,
    );
  }
}

class ChangePasswordService {
  final ApiService apiService = ApiService();

  Future<changeRespons?> changePassword(
    String oldPassword,
    String newPassword,
    String confirmNewPassword,
  ) async {
    try {
      final response = await apiService.post(
        url: AppEndpoints.changeRespons,
        data: {
          "current_password": oldPassword,
          "new_password": newPassword,
          "new_password_confirmation": confirmNewPassword,
        },
      );

      return changeRespons.fromJson(response.data);
    } catch (e) {
      print("change Error Server: $e");
      return changeRespons(message: "حدث خطأ غير متوقع", status: 500);
    }
  }
}
