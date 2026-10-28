import 'package:edufy/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../core/config/app_endpoint.dart';
import '../../../core/helpers/api_service.dart';

class AuthResponse {
  final String? token;
  final User? user;
  final int? status;
  final String? message;

  AuthResponse({this.token, this.user, this.message, this.status});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"];
    return AuthResponse(
      token: data != null ? data["token"] ?? "" : "",
      user: data != null ? User.fromMap(data["user"]) : null,
      message: json["message"] ?? "",
      status: json["status"] ?? 0,
    );
  }
}

class LoginService {
  final ApiService apiService = ApiService();

  Future<AuthResponse?> login(String email, String password) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print('🔥 FCM TOKEN: $fcmToken');

      final response = await apiService.post(
        url: AppEndpoints.login,
        data: {
          "email": email,
          "password": password,
          if (fcmToken != null) "fcm_token": fcmToken,
        },
      );

      return AuthResponse.fromJson(response.data);
    } catch (e) {
      print("Login Error Server: $e");
      return AuthResponse(
        user: null,
        message: "حدث خطأ غير متوقع",
        status: 500,
      );
    }
  }
}
