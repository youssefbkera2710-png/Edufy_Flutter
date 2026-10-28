import 'package:get/get.dart';
import '../../models/gallery.dart';
import 'gallery_service.dart';

class GalleryController extends GetxController {
  var isLoadingAll = false.obs;
  var isLoadingDetails = false.obs;
  var isLoadingMore = false.obs;

  var allGalleries = <GalleryModel>[].obs;
  var galleryDetailsData = Rxn<GalleryModel>();

  int _currentPage = 1;
  bool _hasNextPage = true;

  @override
  void onInit() {
    fetchAllGalleries();
    super.onInit();
  }

  void fetchAllGalleries() async {
    try {
      isLoadingAll(true);
      _currentPage = 1;
      _hasNextPage = true;

      var result = await GalleryService.getAllGalleries(page: _currentPage);

      if (result != null && result.data != null) {
        allGalleries.assignAll(result.data!);

        if (result.pagination != null) {
          _hasNextPage = result.pagination!.hasMorePages ?? false;
        } else {
          _hasNextPage = false;
        }
      }
    } catch (e) {
      print("Error fetching galleries: $e");
    } finally {
      isLoadingAll(false);
    }
  }

  void fetchMoreGalleries() async {

    if (isLoadingAll.value || isLoadingMore.value || !_hasNextPage) return;

    try {
      isLoadingMore(true);
      int nextPage = _currentPage + 1;

      var result = await GalleryService.getAllGalleries(page: nextPage);

      if (result != null && result.data != null && result.data!.isNotEmpty) {
        _currentPage = nextPage;
        allGalleries.addAll(result.data!);
        if (result.pagination != null) {
          _hasNextPage = result.pagination!.hasMorePages ?? false;
        } else {
          _hasNextPage = false;
        }
      } else {
        _hasNextPage = false;
      }
    } catch (e) {
      print("Error fetching more galleries: $e");
    } finally {
      isLoadingMore(false);
    }
  }

  void fetchGalleryDetails(int id) async {
    try {
      isLoadingDetails(true);
      galleryDetailsData.value = null;
      var result = await GalleryService.getGalleryDetails(id);
      if (result != null) {
        galleryDetailsData.value = result;
      }
    } finally {
      isLoadingDetails(false);
    }
  }
}