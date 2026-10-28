import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';
import 'notifications_controller.dart';
import '../../models/notifications.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

    return ResponsiveWidget(
      builder: (sizer) => Scaffold(
        appBar: AppBar(title: const Text('الاشعارات')),

        body: Obx(() {
          if (controller.isLoading.value && controller.notifications.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.notifications.isEmpty) {
            NoDataWidget(
              message: 'لاتوجد اشعارات',
              icon: Icons.notifications_paused,
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(sizer.w(18)),
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    final isLast = index == controller.notifications.length - 1;
                    return Column(
                      children: [
                        _buildNotificationCard(
                          context,
                          notification,
                          sizer,
                          controller,
                        ),
                        SizedBox(height: sizer.h(4)),
                        if (!isLast) _buildDivider(sizer),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItem notification,
    Sizer sizer,
    NotificationsController controller,
  ) {
    return InkWell(
      onTap: () => controller.onNotificationTap(notification),
      borderRadius: BorderRadius.circular(sizer.radius(12)),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: sizer.h(10),
          horizontal: sizer.w(10),
        ),
        decoration: BoxDecoration(
          color: notification.isRead
              ? context.backgroundColortheme
              : Colors.blue[50],
          borderRadius: BorderRadius.circular(sizer.radius(12)),
          border: notification.isRead
              ? null
              : Border.all(color: Colors.blue, width: 0.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: sizer.fontSize(16),
                      fontWeight: FontWeight.bold,
                      color: notification.isRead
                          ? Theme.of(context).colorScheme.onBackground
                          : Colors.black,
                    ),
                  ),
                  SizedBox(height: sizer.h(4)),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: sizer.fontSize(14),
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: sizer.h(4)),
                  Text(
                    _formatDate(notification.createdAt),
                    style: TextStyle(
                      fontSize: sizer.fontSize(12),
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: sizer.w(10),
                height: sizer.w(10),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(Sizer sizer) {
    return Divider(
      height: sizer.h(1),
      thickness: 0.7,
      color: Colors.grey..shade400,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}
