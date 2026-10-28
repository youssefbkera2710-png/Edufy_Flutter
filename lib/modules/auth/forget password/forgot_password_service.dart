import 'package:edufy/core/config/app_endpoint.dart';
import 'package:edufy/core/helpers/api_service.dart';

class ForgotPasswordResponse {
  final int? status;
  final String? message;

  ForgotPasswordResponse({this.status, this.message});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      status: json["status"] ?? 0,
      message: json["message"] ?? "",
    );
  }
}

class ForgotPasswordService {
  final ApiService apiService = ApiService();

  Future<ForgotPasswordResponse?> sendResetOtp(String email) async {
    try {
      final response = await apiService.post(
        url: AppEndpoints.forgotPassword,
        data: {"email": email},
      );
      return ForgotPasswordResponse.fromJson(response.data);
    } catch (e) {
      return ForgotPasswordResponse(
        message: "حدث خطأ غير متوقع",
        status: 500,
      );
    }
  }
}
