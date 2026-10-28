import 'package:dio/dio.dart';
import 'dio_client.dart';

class ApiService {
  final Dio dio = DioClient.dio;

  Future<Response> get({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    try {
      return await dio.get(url, queryParameters: query);
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  Future<Response> post({
    required String url,
    dynamic data,
    Options? options,
  }) async {
    try {
      return await dio.post(
        url,
        data: data,
        options:
            options ??
            Options(
              receiveTimeout: const Duration(minutes: 2),
              sendTimeout: const Duration(minutes: 2),
            ),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  Future<Response> put({required String url, dynamic data}) async {
    try {
      return await dio.put(url, data: data);
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  Future<Response> delete({required String url}) async {
    try {
      return await dio.delete(url);
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  // 🔥 Multipart
  Future<Response> upload({
    required String url,
    required Map<String, dynamic> fields,
    required List<String> filePaths,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        ...fields,
        "images[]": await Future.wait(
          filePaths.map((path) => MultipartFile.fromFile(path)),
        ),
      });

      return await dio.post(url, data: formData);
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }
}
