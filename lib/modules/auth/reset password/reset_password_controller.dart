import 'package:get/get.dart';
import 'reset_password_service.dart';

class ResetPasswordController extends GetxController {
  final ResetPasswordService service = ResetPasswordService();

  var isLoading = false.obs;
  var email = ''.obs;
  var newPassword = ''.obs;
  var passwordConfirmation = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      email.value = Get.arguments["email"];
      print('Email: ${email.value}');
    } else {
      print('❌ ERROR: No arguments passed to ResetPasswordController');
      Get.snackbar('خطأ', 'حدث خطأ، يرجى المحاولة مرة أخرى');
    }
  }

  Future<ResetPasswordResponse?> resetPassword() async {
    isLoading.value = true;
    try {
      print('=== Calling resetPassword API ===');
      print('Email: ${email.value}');

      final result = await service.resetPassword(
        email: email.value,
        password: newPassword.value,
        passwordConfirmation: passwordConfirmation.value,
      );
      return result;
    } catch (e) {
      print("Login Controller Error: $e");
      return ResetPasswordResponse(message: "حدث خطأ غير متوقع", status: 0);
    } finally {
      isLoading.value = false;
    }
  }
}
