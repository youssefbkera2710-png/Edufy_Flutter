import 'package:edufy/core/helpers/notification_router.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:get/get.dart';
import '../../models/notifications.dart';
import 'notifications_service.dart';

class NotificationsController extends GetxController {
  final NotificationsService _service = NotificationsService();

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;

  final RxInt unreadCount = 0.obs;
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;

  int _currentPage = 1;
  int _lastPage = 1;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  @override
  void onClose() {
    _updateHomeNotificationCount();
    super.onClose();
  }

  void _updateHomeNotificationCount() {
    try {
      final homeController = Get.find<HomeController>();
      homeController.loadNotificationCount();
      print('✅ Home notification count updated from NotificationsScreen');
    } catch (e) {
      print('❌ Error updating home count: $e');
    }
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    await Future.wait([fetchNotifications(reset: true), fetchUnreadCount()]);
    isLoading.value = false;
  }

  Future<void> fetchNotifications({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      hasMore.value = true;
      notifications.clear();
    }

    if (!hasMore.value) return;
    if (_currentPage > 1) isLoadingMore.value = true;

    final result = await _service.getNotifications(page: _currentPage);

    if (result != null) {
      notifications.addAll(result.data);

      if (result.pagination != null) {
        _lastPage = result.pagination!.lastPage;
        hasMore.value = _currentPage < _lastPage;
        _currentPage++;
      } else {
        // إذا ما في pagination
        hasMore.value = false;
      }
    }

    isLoadingMore.value = false;
  }

  Future<void> onNotificationTap(NotificationItem notification) async {
    if (!notification.isRead) {
      await readNotification(notification.id);
    }

    await Future.delayed(const Duration(milliseconds: 150));
    NotificationRouter.navigate(notification);
  }

  Future<void> fetchUnreadCount() async {
    unreadCount.value = await _service.unreadCountNotification();
  }

  Future<void> readNotification(String id) async {
    final success = await _service.readNotification(id);
    print('read success = $success');

    if (success) {
      await fetchAll();
      _updateHomeNotificationCount();
    }
  }

  // Future<void> readAll() async {
  //   final success = await _service.readAllNotification();
  //   if (success) {
  //     fetchAll();
  //   }
  // }
}
