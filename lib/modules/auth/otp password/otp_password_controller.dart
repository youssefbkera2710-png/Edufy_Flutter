import 'dart:async';
import 'package:get/get.dart';
import 'otp_password_service.dart';

class OtpPasswordController extends GetxController {
  RxInt remainingSeconds = 600.obs;
  RxString timerText = "10:00".obs;

  RxBool isLoading = false.obs;

  late String email;

  Timer? timer;
  OtpPasswordService service = OtpPasswordService();

  // ================= TIMER =================
  void startTimer() {
    timer?.cancel();
    remainingSeconds.value = 600;

    updateTimerText();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
        updateTimerText();
      } else {
        t.cancel();
      }
    });
  }

  void updateTimerText() {
    final minutes = (remainingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    timerText.value = "$minutes:$seconds";
  }

  // ================= RESEND =================
  Future<OtpPasswordServiceModel?> resendCode() async {
    isLoading.value = true;
    try {
      final result = await service.resendOtp(email);

      if (result != null && result.status == 200) {
        startTimer();
      }
      return result;
    } catch (e) {
      print("Login Controller Error: $e");
      return OtpPasswordServiceModel(message: "حدث خطأ غير متوقع", status: 0);
    } finally {
      isLoading.value = false;
    }
  }

  // ================= VERIFY =================
  Future<OtpPasswordServiceModel?> verifyOtp(String code) async {
    isLoading.value = true;
    try {
      final result = await service.verifyOtp(email, code);
      return result;
    } catch (e) {
      print("Login Controller Error: $e");
      return OtpPasswordServiceModel(message: "حدث خطأ غير متوقع", status: 0);
    } finally {
      isLoading.value = false;
    }
  }

  // ================= INIT =================
  @override
  void onInit() {
    if (Get.arguments != null) {
      email = Get.arguments;
    }

    startTimer();
    super.onInit();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
