import 'package:get/get.dart';
import 'forgot_password_service.dart';

class ForgotPasswordController extends GetxController {
  final ForgotPasswordService service = ForgotPasswordService();

  var isLoading = false.obs;

  var email = ''.obs;

  Future<ForgotPasswordResponse?> sendResetOtp() async {
    isLoading.value = true;

    try {
      final result = await service.sendResetOtp(email.value);

      return result;
    } catch (e) {
      print("Forgot Password Controller Error: $e");
      return ForgotPasswordResponse(message: "حدث خطأ غير متوقع", status: 0);
    } finally {
      isLoading.value = false;
    }
  }
}
