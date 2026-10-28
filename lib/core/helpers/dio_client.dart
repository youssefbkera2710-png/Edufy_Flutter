import 'package:dio/dio.dart';
import 'package:edufy/core/config/app_endpoint.dart';
import 'package:edufy/core/config/user_info.dart';

class DioClient {
  static final Dio dio =
  Dio(
    BaseOptions(
      baseUrl: AppEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (UserInfo.token != null) {
            options.headers['Authorization'] = 'Bearer ${UserInfo.token}';
          }
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options);
        },
        onError: (error, handler) {
          // 🔴 لا يوجد إنترنت
          if (error.type == DioExceptionType.connectionError ||
              error.type == DioExceptionType.connectionTimeout) {}
          return handler.next(error);
        },
      ),
    );
}