import 'package:get/get.dart';
import 'change_password_service.dart';

class ChangePasswordController extends GetxController {
  final ChangePasswordService service = ChangePasswordService();

  var oldPassword = '';
  var newPassword = '';
  var confirmNewPassword = '';

  var isLoading = false.obs;

  Future<changeRespons?> changePassword() async {
    isLoading.value = true;

    try {
      final result = await service.changePassword(
        oldPassword,
        newPassword,
        confirmNewPassword,
      );

      return result;
    } catch (e) {
      return changeRespons(message: "حدث خطأ غير متوقع", status: 500);
    } finally {
      isLoading.value = false;
    }
  }
}
