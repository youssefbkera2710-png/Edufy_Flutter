import 'package:edufy/core/constants/string_text.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/progress_def.dart';
import 'package:edufy/core/shared/widgets/snackbar_def.dart';
import 'package:edufy/modules/auth/widgets/text_form_field_def.dart';
import 'package:edufy/components/wave_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';
import '../../../core/res/validator_def.dart';
import '../../../core/shared/widgets/elevated_button_def.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ForgotPasswordController controller = Get.put(
    ForgotPasswordController(),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WaveHeader(context, AppString.forgotPasswordTitle),
      body: ResponsiveWidget(
        builder: (sizer) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: sizer.w(30)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: sizer.w(110),
                    height: sizer.w(110),
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: sizer.h(20)),

                  Text(
                    AppString.forgotPasswordDescription,
                    textAlign: TextAlign.center,
                    style: context.bodyMedium?.copyWith(color: context.grey750),
                  ),

                  SizedBox(height: sizer.h(40)),

                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormFieldDeF(
                          controller: emailController,
                          label: AppString.emailLabel,
                          keyboard: TextInputType.emailAddress,
                          paddingTop: sizer.h(0),
                          validator: (p0) => ValidatorDef.validatorEmail(p0),
                          maxLines: 1,
                        ),

                        SizedBox(height: sizer.h(40)),

                        ElevatedButtonDef(
                          press: () async {
                            if (formKey.currentState!.validate()) {
                              controller.email.value = emailController.text;
                              progressDef(context);
                              final result = await controller.sendResetOtp();
                              Get.back();
                              if (result != null && result.status == 200) {
                                print('Navigating to reset-pass-otp with:');
                                print('email: ${controller.email.value}');

                                Get.toNamed(
                                  '/OtpPasswordScreen',
                                  arguments: controller.email.value,
                                );
                                snackBarDef(
                                  AppString.resetPasswordSuccessTitle,
                                  result.message ?? "نجاح تسجيل الدخول",
                                );
                              } else {
                                snackBarDef(
                                  AppString.resetPasswordErrorTitle,
                                  result?.message ?? "حدث خطأ غير متوقع",
                                );
                              }
                            }
                          },
                          text: AppString.sendOtpButton,
                        ),

                        SizedBox(height: sizer.h(20)),

                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            AppString.backToLogin,
                            style: context.bodyRegular?.copyWith(
                              color: context.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
