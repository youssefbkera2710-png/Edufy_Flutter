import 'package:edufy/core/constants/string_text.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/progress_def.dart';
import 'package:edufy/core/shared/widgets/snackbar_def.dart';
import 'package:edufy/modules/auth/widgets/text_form_field_password_def.dart';
import 'package:edufy/components/wave_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';
import '../../../core/res/validator_def.dart';
import '../../../core/shared/widgets/elevated_button_def.dart';
import 'reset_password_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ResetPasswordController controller = Get.put(ResetPasswordController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WaveHeader(context, AppString.resetPasswordTitle),
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
                    AppString.resetPasswordDescription,
                    textAlign: TextAlign.center,
                    style: context.bodyMedium?.copyWith(color: context.grey750),
                  ),

                  SizedBox(height: sizer.h(40)),

                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormFielPassword(
                          controller: passwordController,
                          label: AppString.newPasswordLabel,
                          paddingTop: sizer.h(0),
                          validator: (p0) => ValidatorDef.validatorPassword(p0),
                        ),

                        SizedBox(height: sizer.h(20)),

                        TextFormFielPassword(
                          controller: confirmPasswordController,
                          label: AppString.confirmPasswordLabel,
                          paddingTop: sizer.h(0),
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return AppString.confirmPasswordRequired;
                            }
                            if (p0 != passwordController.text) {
                              return AppString.passwordsDoNotMatch;
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: sizer.h(40)),

                        ElevatedButtonDef(
                          press: () async {
                            if (formKey.currentState!.validate()) {
                              controller.newPassword.value =
                                  passwordController.text;
                              controller.passwordConfirmation.value =
                                  confirmPasswordController.text;
                              progressDef(context);
                              final result = await controller.resetPassword();

                              if (result != null && result.status == 200) {
                                snackBarDef(
                                  AppString.resetPasswordSuccessTitle,
                                  result.message ?? "تم ارسال otp بنجاح",
                                );
                                Get.offAllNamed('/login');
                              } else {
                                snackBarDef(
                                  AppString.resetPasswordErrorTitle,
                                  result?.message ?? "حدث خطأ غير متوقع",
                                );
                              }
                            }
                          },
                          text: AppString.resetPasswordButton,
                        ),

                        SizedBox(height: sizer.h(20)),

                        TextButton(
                          onPressed: () {
                            Get.offAllNamed('/login');
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
