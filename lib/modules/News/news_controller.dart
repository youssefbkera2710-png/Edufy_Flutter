import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/news.dart';
import 'news_service.dart';

class NewsController extends GetxController {
  final NewsService _service = NewsService();

  var isLoadingList = false.obs;
  var isLoadingMore = false.obs;
  var newsList = <NewsData>[].obs;

  int _currentPage = 1;
  bool _hasMorePages = true;
  final ScrollController scrollController = ScrollController();

  var isLoadingDetails = false.obs;
  var newsDetailsData = Rxn<NewsData>();

  @override
  void onInit() {
    super.onInit();
    fetchInitialNews();
    _setupScrollController();
  }

  Future<void> fetchInitialNews() async {
    isLoadingList.value = true;
    _currentPage = 1;
    _hasMorePages = true;
    newsList.clear();

    final response = await _service.fetchNewsList(_currentPage);
    if (response != null && response.data != null) {
      newsList.assignAll(response.data!);
      _hasMorePages = response.pagination?.hasMorePages ?? false;
    }
    isLoadingList.value = false;
  }

  void _setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        fetchMoreNews();
      }
    });
  }

  Future<void> fetchMoreNews() async {
    if (isLoadingMore.value || !_hasMorePages) return;

    isLoadingMore.value = true;
    _currentPage++;

    final response = await _service.fetchNewsList(_currentPage);
    if (response != null && response.data != null) {
      newsList.addAll(response.data!);
      _hasMorePages = response.pagination?.hasMorePages ?? false;
    } else {
      _currentPage--;
    }
    isLoadingMore.value = false;
  }

  Future<void> fetchNewsDetails(int id) async {
    isLoadingDetails.value = true;
    newsDetailsData.value = null;

    final response = await _service.fetchNewsDetails(id);
    if (response != null && response.data != null) {
      newsDetailsData.value = response.data;
    }
    isLoadingDetails.value = false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}