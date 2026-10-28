import 'package:edufy/core/config/user_info.dart';
import 'package:edufy/core/services/local_storage.dart';
import 'package:edufy/models/user.dart';
import 'package:edufy/modules/auth/login/login_service.dart';

class UserLocalService {
  final LocalStorage storage = LocalStorage();

  Future<void> saveUser(AuthResponse result) async {
    await storage.save('token', result.token ?? "");
    await storage.save('email', result.user?.email ?? "");
    await storage.save('id', result.user?.id.toString() ?? "");
    await storage.save('name', result.user?.name ?? "");
    await storage.save('phone', result.user?.phone ?? "");
    await storage.save('role', result.user?.role ?? "");
    await storage.save('avatar', result.user?.avatar ?? "");
    await storage.save('createdAt', result.user?.createdAt.toString() ?? "");

    _fillUserInfo(result);
  }

  Future<void> updateUser(User user) async {
    await storage.save('name', user.name ?? "");
    await storage.save('phone', user.phone ?? "");
    await storage.save('avatar', user.avatar ?? "");
    await storage.save('email', user.email ?? "");
    UserInfo.name = user.name ?? "";
    UserInfo.phone = user.phone ?? "";
    UserInfo.avatar = user.avatar ?? "";
    UserInfo.email = user.email ?? "";
  }

  void _fillUserInfo(AuthResponse result) {
    UserInfo.token = result.token;
    UserInfo.id = result.user?.id.toString();
    UserInfo.name = result.user?.name;
    UserInfo.phone = result.user?.phone;
    UserInfo.role = result.user?.role;
    UserInfo.avatar = result.user?.avatar;
    UserInfo.createdAt = result.user?.createdAt.toString();
    UserInfo.email = result.user?.email;
  }
}
