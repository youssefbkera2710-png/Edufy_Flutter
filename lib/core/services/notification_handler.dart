import 'package:edufy/modules/home/home_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../modules/notification/notifications_screen.dart';

class NotificationHandler {
  static RemoteMessage? initialMessage;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // تهيئة الإشعارات المحلية
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(settings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel',
      'الإشعارات',
      description: 'قناة الإشعارات العامة',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // لما التطبيق مفتوح
    FirebaseMessaging.onMessage.listen((message) async {
      _showNotification(message);

      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().loadNotificationCount();
      }
    });

    // لما يضغط على الإشعار والتطبيق بالخلفية
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().loadNotificationCount();
      }

      Get.to(() => const NotificationsScreen());
    });
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'الإشعارات',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      0,
      message.notification?.title ?? 'Edufy',
      message.notification?.body ?? '',
      details,
    );
  }
}
