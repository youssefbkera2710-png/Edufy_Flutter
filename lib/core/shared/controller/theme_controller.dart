import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:edufy/core/services/local_storage.dart';

class ThemeController extends GetxController {
  final storage = LocalStorage();
  var isDarkMode = true.obs;

  @override
  void onInit() async {
    isDarkMode.value = await storage.read('isDarkMode') == "true";
    super.onInit();
  }


  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    await storage.save('isDarkMode', "${isDarkMode.value}");
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
