import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edufy/core/config/user_locale_services.dart';
import 'package:edufy/models/user.dart';

import '../../../core/config/app_endpoint.dart';
import '../../../core/helpers/api_service.dart';

class profileUpdated {
  final User? user;
  final int? status;
  final String? message;

  profileUpdated({this.user, this.message, this.status});

  factory profileUpdated.fromJson(Map<String, dynamic> json) {
    final data = json["data"];
    return profileUpdated(
      user: data != null ? User.fromMap(data) : null,
      message: json["message"] ?? "",
      status: json["status"] ?? 0,
    );
  }
}

class EditProfileService {
  final ApiService apiService = ApiService();

  Future<profileUpdated?> updateProfile({
    required String phone,
    File? image,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "phone": phone,
        if (image != null) "avatar": await MultipartFile.fromFile(image.path),
      });

      final response = await apiService.post(
        url: AppEndpoints.getUserData,
        data: formData,
      );

      return profileUpdated.fromJson(response.data);
    } catch (e) {
      print("profile Error Server: $e");
      return profileUpdated(
        user: null,
        message: "حدث خطأ غير متوقع",
        status: 500,
      );
    }
  }

  Future<profileUpdated?> syncProfile() async {
    try {
      final response = await apiService.get(url: AppEndpoints.getUserData);
      final result = profileUpdated.fromJson(response.data);
      if (result.status == 200 && result.user != null) {
        final userLocal = UserLocalService();

        await userLocal.updateUser(result.user!);
      }

      return result;
    } catch (e) {
      print("profile Error Server: $e");
      return profileUpdated(
        user: null,
        message: "حدث خطأ غير متوقع",
        status: 500,
      );
    }
  }
}
