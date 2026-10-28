import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportController extends GetxController {
  Future<void> openWhatsApp() async {
    const String phoneNumber = '963943413580';
    const String message = 'مرحباً، لدي استفسار';

    final String encodedMessage = Uri.encodeComponent(message);

    final Uri whatsappUrl = Uri.parse(
      'https://wa.me/$phoneNumber?text=$encodedMessage',
    );

    try {
      final bool canLaunch = await canLaunchUrl(whatsappUrl);

      if (canLaunch) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(whatsappUrl, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'تأكد من تثبيت تطبيق واتساب',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
