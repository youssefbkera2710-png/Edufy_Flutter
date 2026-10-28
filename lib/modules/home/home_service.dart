
import 'package:edufy/core/config/app_endpoint.dart';
import 'package:edufy/core/helpers/api_service.dart';

class HomeService {
  final ApiService apiService = ApiService();

  Future<int> getNotificationCount() async {
    try {
      final response = await apiService.get(url: AppEndpoints.unreadCount);
      print(response.data);
      if (_isSuccessful(response.statusCode!)) {
        final body = response.data;

        return body['data'] ?? 0;
      }
    } catch (e) {
      print('Error getting notification count: $e');
    }

    return 0;
  }

  bool _isSuccessful(int statusCode) => statusCode == 200 || statusCode == 201;
}
