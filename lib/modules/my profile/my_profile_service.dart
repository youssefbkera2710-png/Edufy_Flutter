import '../../../core/config/app_endpoint.dart';
import '../../../core/helpers/api_service.dart';

class MyProfileResponse {
  final int? status;
  final String? message;

  MyProfileResponse({this.message, this.status});

  factory MyProfileResponse.fromJson(Map<String, dynamic> json) {
    return MyProfileResponse(
      message: json["message"] ?? "",
      status: json["status"] ?? 0,
    );
  }
}

class LogoutService {
  final ApiService apiService = ApiService();

  Future<MyProfileResponse?> logout() async {
    try {
      final response = await apiService.post(
        url: AppEndpoints.logout,
        data: {},
      );
      return MyProfileResponse.fromJson(response.data);
    } catch (e) {
      print("Logout Error Server: $e");
      return MyProfileResponse(message: "حدث خطأ غير متوقع", status: 500);
    }
  }
}
