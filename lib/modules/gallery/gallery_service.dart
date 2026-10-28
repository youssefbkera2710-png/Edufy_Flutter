import 'package:edufy/core/config/app_endpoint.dart';
import '../../core/helpers/dio_client.dart';
import '../../models/gallery.dart';
import '../../models/gallery_pagination.dart';

class GalleryService {
  static Future<GalleryPaginationModel?> getAllGalleries({int page = 1}) async {
    try {
      final response = await DioClient.dio.get(
        AppEndpoints.galleries,
        queryParameters: {
          'page': page,
        },
      );
      if (response.statusCode == 200) {
        return GalleryPaginationModel.fromJson(response.data);
      }
    } catch (e) {
      print("Error fetching galleries: $e");
    }
    return null;
  }

  static Future<GalleryModel?> getGalleryDetails(int id) async {
    try {
      final response = await DioClient.dio.get(AppEndpoints.galleryDetails(id));
      if (response.statusCode == 200) {
        return GalleryModel.fromJson(response.data['data']);
      }
    } catch (e) {
      print("Error fetching gallery details: $e");
    }
    return null;
  }
}