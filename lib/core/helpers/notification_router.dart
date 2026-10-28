import 'package:edufy/core/constants/notifications_types.dart';
import 'package:edufy/modules/dashbord/dashbord_screen.dart';
import 'package:get/get.dart';
import '../../models/notifications.dart';
import '../../modules/notification/notifications_screen.dart';

class NotificationRouter {
  static void navigate(NotificationItem notification) {
    final data = notification.notificationType;
    final meta = notification.meta;

    switch (data) {
      // 1. إشعار عطلة رسمية جديدة (Holiday) -> خبر عام
      case NotificationTypes.holiday:
        Get.toNamed('/newsDetailsScreen');
        break;

      // 2. إشعار طلب عذر غياب (لولي الأمر عند التقديم) -> صفحة الاعذار
      // 3. إشعار قبول/رفض طلب العذر (لولي الأمر) -> صفحة الاعذار
      case NotificationTypes.absenceRequest:
        final studentName = meta?['student_name'] ?? 'الطالب';
        final absenceRequestId = meta?['absence_request_id'];
        if (absenceRequestId != null) {
          Get.toNamed(
            '/AbsenceRequestsPage',
            arguments: {
              'studentName': studentName,
              'absenceRequestId': absenceRequestId,
              'openDetailsDialog': true,
            },
          );
        } else {
          // في حال عدم وجود الـ ID، نفتح الصفحة بشكل عادي
          Get.toNamed(
            '/AbsenceRequestsPage',
            arguments: {'studentName': studentName},
          );
        }
        break;

      // 4. إشعار تعيين معلم بديل -> جدول المعلم
      case NotificationTypes.alterationTeacher:
        Get.off(
          () => const DashboardScreen(initialIndex: 1),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 300),
        );
        break;

      // 5. إشعار محتوى تعليمي جديد -> صفحة تفاصيل المحتوى
      // 7. إشعار تعليق جديد / رد -> صفحة تفاصيل المحتوى
      case NotificationTypes.contentFromTeacher:
      case NotificationTypes.newCommentOrReply:
        final contentId = meta?['educational_content_id'] ?? meta?['id'];
        if (contentId != null) {
          Get.toNamed(
            '/EducationalDetailsScreen',
            arguments: {'id': contentId},
          );
        } else {
          Get.off(
            () => const DashboardScreen(initialIndex: 3),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 300),
          );
        }
        break;

      // 6. إشعار واجب منزلي جديد -> صفحة الواجبات (الطلاب)
      case NotificationTypes.newHomework:
        // يمكن إضافة الـ classId أو studentId إذا احتجت
        Get.toNamed('/student/homeworks');
        break;

      // 8. إشعار اختبار جديد -> صفحة الاختبارات
      case NotificationTypes.newExams:
        // نحتاج studentId من الـ meta
        final studentId = meta?['student_id'];
        if (studentId != null) {
          Get.toNamed('/ExamsScreen', arguments: {'studentId': studentId});
        } else {
          Get.to(() => NotificationsScreen());
        }
        break;

      // 9. إشعار درجة جديدة -> صفحة العلامات
      case NotificationTypes.gradeForSubject:
        final studentId = meta?['student_id'];
        if (studentId != null) {
          Get.toNamed('/gradeScreen', arguments: {'studentId': studentId});
        } else {
          Get.to(() => NotificationsScreen());
        }
        break;

      // 10. إشعار ترقية طالب -> سجل الصفوف
      case NotificationTypes.studentPromoted:
        final studentId = meta?['student_id'];
        if (studentId != null) {
          Get.toNamed(
            '/classHistoryScreen',
            arguments: {'studentId': studentId},
          );
        } else {
          Get.to(() => NotificationsScreen());
        }
        break;

      // 11. إشعار فاتورة جديدة -> فواتير الابن
      case NotificationTypes.feeReminder:
        // نفحص إذا كانت الفاتورة خاصة بالابن أو دفع عام
        // بناءً على وجود student_id في meta
        final studentId = meta?['student_id'];
        final studentName = meta?['student_name'] ?? 'الطالب';

        if (studentId != null) {
          // فاتورة لابن محدد
          Get.toNamed(
            '/InvoicesScreen',
            arguments: {'studentName': studentName},
          );
        } else {
          // فاتورة عامة أو دفع
          Get.toNamed(
            '/paymentsHistoryScreen',
            arguments: {'paymentHistory': [], 'totalPaid': 0},
          );
        }
        break;

      // 12. إشعار تأكيد دفع فاتورة -> سجل المدفوعات (للأب)
      case NotificationTypes.feePaymentConfirmation:
        // بما أن التأكيد يخص الأب، نذهب لصفحة المدفوعات العامة
        Get.toNamed(
          '/paymentsHistoryScreen',
          arguments: {'paymentHistory': [], 'totalPaid': 0},
        );
        break;

      // 13. إشعار عام (إعلان) -> قائمة الأخبار
      case NotificationTypes.popGeneral:
        Get.toNamed('/newsListScreen');
        break;

      default:
        Get.to(() => NotificationsScreen());
    }
  }
}
