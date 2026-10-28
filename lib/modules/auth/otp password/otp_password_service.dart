import 'package:edufy/core/config/app_endpoint.dart';
import 'package:edufy/core/helpers/api_service.dart';

class OtpPasswordServiceModel {
  final int? status;
  final String? message;

  OtpPasswordServiceModel({this.status, this.message});

  factory OtpPasswordServiceModel.fromJson(Map<String, dynamic> json) {
    return OtpPasswordServiceModel(
      status: json["status"] ?? 0,
      message: json["message"] ?? "",
    );
  }
}

class OtpPasswordService {
  final ApiService apiService = ApiService();

  Future<OtpPasswordServiceModel?> verifyOtp(String email, String otp) async {
    try {
      final response = await apiService.post(
        url: AppEndpoints.verifyOTP,
        data: {"email": email, "otp": otp.toString()},
      );
      return OtpPasswordServiceModel.fromJson(response.data);
    } catch (e) {
      return OtpPasswordServiceModel(message: "حدث خطأ غير متوقع", status: 500);
    }
  }

  Future<OtpPasswordServiceModel?> resendOtp(String email) async {
    try {
      final response = await apiService.post(
        url: AppEndpoints.resendOTP,
        data: {"email": email},
      );

      return OtpPasswordServiceModel.fromJson(response.data);
    } catch (e) {
      return OtpPasswordServiceModel(message: "حدث خطأ غير متوقع", status: 500);
    }
  }
}
