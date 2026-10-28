import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoConnectionController extends GetxController {
  var isConnected = true.obs;
  bool wasDisconnected = false;
  bool isSnackbarOpen = false;

  @override
  void onInit() async {
    super.onInit();
    var result = await Connectivity().checkConnectivity();
    isConnected.value = result != ConnectivityResult.none;

    Connectivity().onConnectivityChanged.listen((results) {
      final result = results.first;

      bool nowConnected = result != ConnectivityResult.none;
      final isSplash = Get.currentRoute == '/splash';

      if (!nowConnected) {
        isConnected.value = false;
        wasDisconnected = true;

        if (!isSplash && !isSnackbarOpen) {
          isSnackbarOpen = true;

          Get.rawSnackbar(
            message: "لا يوجد اتصال بالإنترنت",
            backgroundColor: Colors.red,
            duration: const Duration(days: 1),
            isDismissible: false,
            margin: const EdgeInsets.all(10),
            borderRadius: 8,
            mainButton: TextButton(
              onPressed: () {
                Get.closeCurrentSnackbar();
              },
              child: const Text(
                "✕",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );
        }
      }
      else {
        isConnected.value = true;

        if (isSnackbarOpen) {
          Get.closeCurrentSnackbar();
          isSnackbarOpen = false;
        }

        if (wasDisconnected) {
          Get.rawSnackbar(
            message: "أنت متصل بالإنترنت",
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(10),
            isDismissible: false,
            borderRadius: 8,
            mainButton: TextButton(
              onPressed: () {
                Get.closeCurrentSnackbar();
              },
              child: const Text(
                "✕",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );

          wasDisconnected = false;
        }
      }
    });
  }
}
