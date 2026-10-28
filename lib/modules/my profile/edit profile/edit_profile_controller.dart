import 'dart:io';
import 'package:edufy/core/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/config/user_info.dart';
import 'edit_profile_service.dart';

class EditProfileController extends GetxController {
  final EditProfileService service = EditProfileService();
  var isLoading = false.obs;

  final nameController = TextEditingController(text: UserInfo.name);
  final emailController = TextEditingController(text: UserInfo.email);
  final phoneController = TextEditingController(text: UserInfo.phone);
  final createdController = TextEditingController(text: UserInfo.createdAt);
  var avatarUrl = RxString(UserInfo.avatar ?? '');
  var imageFile = Rx<File?>(null);

  /// 📸 اختيار صورة
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      imageFile.value = File(picked.path);
    }
  }

  Future<void> syncProfile() async {
    final result = await service.syncProfile();

    if (result != null && result.status == 200) {
      nameController.text = result.user?.name ?? "";
      phoneController.text = result.user?.phone ?? "";
      emailController.text = result.user?.email ?? "";
      avatarUrl.value = result.user?.avatar ?? '';
      update();
    }
  }

  Future<profileUpdated?> updateProfile() async {
    isLoading.value = true;
    try {
      final result = await service.updateProfile(
        phone: phoneController.text,
        image: imageFile.value,
      );

      if (result != null && result.status == 200) {
        final LocalStorage storage = LocalStorage();
        await storage.save('phone', result.user?.phone ?? "");
        UserInfo.phone = phoneController.text;
        if (imageFile.value != null) {
          await storage.save('avatar', result.user?.avatar ?? "");
          avatarUrl.value = result.user?.avatar ?? "";
          UserInfo.avatar = avatarUrl.value;
          imageFile.value = null;
        }
      }

      return result;
    } catch (e) {
      print("Login Controller Error: $e");
      return profileUpdated(message: "حدث خطأ غير متوقع", status: 0);
    } finally {
      isLoading.value = false;
    }
  }
}
