import 'dart:convert';
import 'package:edufy/models/notifications.dart';

import '../../../core/config/app_endpoint.dart';
import '../../../core/helpers/api_service.dart';

class NotificationsService {
  final ApiService apiService = ApiService();

  Future<NotificationsResponse?> getNotifications({int page = 1}) async {
    try {
      var response = await apiService.get(
        url: AppEndpoints.getNotifications,
        query: {'page': page.toString()},
      );

      print('📥 Notifications response status: ${response.statusCode}');
      print('📥 Notifications response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonData;

        if (response.data is String) {
          jsonData = jsonDecode(response.data);
        } else if (response.data is Map) {
          jsonData = response.data as Map<String, dynamic>;
        } else {
          print('❌ Unknown response data type: ${response.data.runtimeType}');
          return null;
        }

        print('📦 Parsed jsonData: $jsonData');
        return NotificationsResponse.fromJson(jsonData);
      } else {
        print('❌ Failed to get notifications: ${response.statusCode}');
        return null;
      }
    } catch (e, stackTrace) {
      print('❌ Error in getNotifications: $e');
      print('📚 StackTrace: $stackTrace');
      return null;
    }
  }

  Future<bool> readNotification(String id) async {
    try {
      final response = await apiService.post(
        url: "${AppEndpoints.read}/$id/mark-read",
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('❌ readNotification error: $e');
      return false;
    }
  }

  // Future<bool> readAllNotification() async {
  //   try {
  //     final response = await apiService.post(
  //       subUrl: AppEndpoints.readAll,
  //       headers: {
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer ${UserInfo.token}',
  //       },
  //     );

  //     return response.statusCode == 200 || response.statusCode == 201;
  //   } catch (e) {
  //     print('readAllNotification error: $e');
  //     return false;
  //   }
  // }

  Future<int> unreadCountNotification() async {
    try {
      final response = await apiService.get(url: AppEndpoints.unreadCount);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data;
        return body['data'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('unreadCountNotification error: $e');
      return 0;
    }
  }
}
