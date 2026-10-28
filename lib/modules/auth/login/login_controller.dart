import 'package:edufy/core/config/user_locale_services.dart';
import 'package:edufy/modules/auth/login/login_service.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final LoginService service = LoginService();

  var email = '';
  var password = '';

  var isLoading = false.obs;

  Future<AuthResponse?> loginOnClick() async {
    isLoading.value = true;

    try {
      final result = await service.login(email, password);

      if (result != null && result.status == 200) {
        final userLocal = UserLocalService();
        await userLocal.saveUser(result);
      }

      return result;
    } catch (e) {
      print("Login Controller Error: $e");
      return AuthResponse(message: "حدث خطأ غير متوقع", status: 0);
    } finally {
      isLoading.value = false;
    }
  }
}
