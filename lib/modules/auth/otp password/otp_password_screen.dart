import 'package:edufy/core/constants/string_text.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/progress_def.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'otp_password_controller.dart';
import '../../../core/shared/widgets/snackbar_def.dart';
import '../../../components/wave_header.dart';
import 'package:responsive_s/responsive_s.dart';

class OtpPasswordScreen extends StatelessWidget {
  final OtpPasswordController controller = Get.put(OtpPasswordController());

  OtpPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ResponsiveWidget(
        builder: (sizer) => Scaffold(
          appBar: WaveHeader(context, AppString.otpTitle),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: sizer.w(20)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: sizer.h(30)),

                  Text(
                    AppString.otpSentToEmail,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: sizer.fontSize(15),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: sizer.h(6)),

                  Text(
                    controller.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: sizer.fontSize(18),
                      fontWeight: FontWeight.bold,
                      color: context.primary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.offNamed('/login');
                    },
                    child: Text(
                      AppString.changeAccount,
                      style: TextStyle(
                        fontSize: sizer.fontSize(14),
                        color: context.primary,
                      ),
                    ),
                  ),

                  SizedBox(height: sizer.h(35)),

                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 6,
                      defaultPinTheme: PinTheme(
                        width: sizer.w(48),
                        height: sizer.h(56),
                        textStyle: TextStyle(
                          fontSize: sizer.fontSize(20),
                          fontWeight: FontWeight.bold,
                          color: context.primary,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                      focusedPinTheme:
                          PinTheme(
                            width: sizer.w(48),
                            height: sizer.h(56),
                            textStyle: TextStyle(
                              fontSize: sizer.fontSize(20),
                              fontWeight: FontWeight.bold,
                              color: context.primary,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                          ).copyWith(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: context.primary,
                                width: 2,
                              ),
                            ),
                            textStyle: TextStyle(
                              color: context.primary,
                              fontSize: sizer.fontSize(20),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      onChanged: (value) {
                        if (kDebugMode) print("OTP partial = $value");
                      },
                      onCompleted: (value) async {
                        if (kDebugMode) print("OTP completed = $value");

                        progressDef(context);

                        final result = await controller.verifyOtp(value);

                        Get.back();

                        if (result != null && result.status == 200) {
                          snackBarDef(
                            AppString.otpSuccessTitle,
                            result.message ?? "نجاح  التحقق",
                          );
                          Get.offNamed(
                            "/reset-password",
                            arguments: {"email": controller.email},
                          );
                        } else {
                          snackBarDef(
                            AppString.otpErrorTitle,
                            result?.message ?? "حدث خطأ غير متوقع",
                          );
                        }
                      },
                      textInputAction: TextInputAction.done,
                      useNativeKeyboard: true,
                    ),
                  ),

                  SizedBox(height: sizer.h(40)),

                  Obx(() {
                    return Text(
                      "${AppString.otpExpiresIn}${controller.timerText.value}",
                      style: TextStyle(
                        fontSize: sizer.fontSize(16),
                        fontWeight: FontWeight.bold,
                        color: context.grey625.withOpacity(0.6),
                      ),
                    );
                  }),

                  SizedBox(height: sizer.h(30)),

                  TextButton(
                    onPressed: () async {
                      progressDef(context);
                      final result = await controller.resendCode();
                      Get.back();
                      if (result != null && result.status == 200) {
                        controller.startTimer();
                        snackBarDef(
                          AppString.otpSuccessTitle,
                          result.message ?? "نجاح  الارسال",
                        );
                      } else {
                        snackBarDef(
                          AppString.otpErrorTitle,
                          result?.message ?? "حدث خطأ غير متوقع",
                        );
                      }
                    },
                    child: Text(
                      AppString.otpResend,
                      style: TextStyle(
                        fontSize: sizer.fontSize(14),
                        color: context.primary,
                      ),
                    ),
                  ),

                  SizedBox(height: sizer.h(30)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
