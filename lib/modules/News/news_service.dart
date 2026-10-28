import 'package:edufy/models/news.dart';

import '../../../core/helpers/api_service.dart';
import '../../../core/config/app_endpoint.dart';


class NewsService {
  final ApiService apiService = ApiService();

  Future<NewsModel?> fetchNewsList(int page) async {
    try {
      final response = await apiService.get(
        url: "${AppEndpoints.news}?page=$page",
      );
      if (response.data != null) {
        return NewsModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("News Service List Error: $e");
      return null;
    }
  }

  Future<NewsDetailsModel?> fetchNewsDetails(int id) async {
    try {
      final response = await apiService.get(
        url: "${AppEndpoints.news}/$id",
      );
      if (response.data != null) {
        return NewsDetailsModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("News Service Details Error: $e");
      return null;
    }
  }
}