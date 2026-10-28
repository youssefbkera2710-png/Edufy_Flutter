import 'package:edufy/core/config/app_endpoint.dart';
import 'package:edufy/core/helpers/api_service.dart';

class ResetPasswordResponse {
  final int? status;
  final String? message;
  ResetPasswordResponse({this.status, this.message});

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      status: json["status"] ?? 0,
      message: json["message"] ?? "",
    );
  }
}

class ResetPasswordService {
  final ApiService apiService = ApiService();

  Future<ResetPasswordResponse?> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await apiService.post(
        url: AppEndpoints.resetPassword,
        data: {
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
      );

      return ResetPasswordResponse.fromJson(response.data);
    } catch (e) {
      return ResetPasswordResponse(message: "حدث خطأ غير متوقع", status: 500);
    }
  }
}
