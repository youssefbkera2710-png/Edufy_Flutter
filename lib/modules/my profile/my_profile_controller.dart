import 'package:edufy/modules/my%20profile/my_profile_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../../../core/config/user_info.dart';
import '../../../core/services/local_storage.dart';

class MyProfileController extends GetxController {
  final LogoutService service = LogoutService();

  var isLoading = false.obs;

  Future<MyProfileResponse?> logoutOnClick() async {
    isLoading.value = true;

    try {
      final result = await service.logout();

      if (result != null && result.status == 200) {
        final storage = LocalStorage();
        final messaging = FirebaseMessaging.instance;
        await storage.remove('token');
        await storage.remove('id');
        await storage.remove('email');
        await storage.remove('name');
        await storage.remove('phone');
        await storage.remove('role');
        await storage.remove('avatar');
        await storage.remove('createdAt');
        await messaging.deleteToken();

        UserInfo.token = null;
        UserInfo.id = null;
        UserInfo.name = null;
        UserInfo.phone = null;
        UserInfo.role = null;
        Get.delete<MyProfileController>();
        // باقي ال controller لو في
      }
      return result;
    } catch (e) {
      print("Login Controller Error: $e");
      return MyProfileResponse(message: "حدث خطأ غير متوقع", status: 0);
    } finally {
      isLoading.value = false;
    }
  }
}
