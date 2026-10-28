import 'package:edufy/core/constants/string_text.dart';
import 'package:edufy/core/shared/controller/support_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/progress_def.dart';
import 'package:edufy/core/shared/widgets/snackbar_def.dart';
import 'package:edufy/modules/auth/widgets/row_divider_text_divider.dart';
import 'package:edufy/modules/auth/widgets/text_form_field_def.dart';
import 'package:edufy/modules/auth/widgets/text_form_field_password_def.dart';
import 'package:edufy/components/wave_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';
import '../../../core/res/validator_def.dart';
import '../../../core/shared/widgets/elevated_button_def.dart';
import 'login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = LoginController();
  final SupportController controllerSupport = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WaveHeader(context, AppString.loginTitle),
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

                  Text(
                    AppString.welcome,
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.primary,
                    ),
                  ),
                  SizedBox(height: sizer.h(20)),

                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormFieldDeF(
                          controller: emailController,
                          label: AppString.emailLabel,
                          keyboard: TextInputType.emailAddress,
                            paddingTop: sizer.h(20),
                          validator: (p0) => ValidatorDef.validatorEmail(p0),
                          maxLines: 1,
                        ),
                        SizedBox(height: sizer.h(10)),

                        TextFormFielPassword(
                          controller: passwordController,
                          label: AppString.passwordLabel,
                          paddingTop: sizer.h(10),
                          validator: (p0) => ValidatorDef.validatorPassword(p0),
                        ),

                        SizedBox(height: sizer.h(10)),

                        TextButton(
                          onPressed: () {
                            Get.toNamed('/forgotPasswordScreen');
                          },
                          child: Text(
                            AppString.forgotPasswordTitle,
                            style: context.bodyRegular!.copyWith(
                              color: context.primary,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),

                        SizedBox(height: sizer.h(20)),

                        ElevatedButtonDef(
                          press: () async {
                            if (formKey.currentState!.validate()) {
                              controller.email = emailController.text;
                              controller.password = passwordController.text;
                              progressDef(context);
                              final result = await controller.loginOnClick();
                              Get.back();
                              if (result != null && result.status == 200) {
                                snackBarDef(
                                  AppString.loginSuccessTitle,
                                  result.message ?? "تم ارسال otp بنجاح",
                                );
                                print(result.token);
                                Get.offAllNamed('/dashboard');
                              } else {
                                snackBarDef(
                                  AppString.loginErrorTitle,
                                  result?.message ?? "حدث خطأ غير متوقع",
                                );
                              }
                            }
                          },
                          text: AppString.loginButton,
                        ),

                        SizedBox(height: sizer.h(15)),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: sizer.w(20),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: sizer.w(16),
                              vertical: sizer.h(12),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(
                                0.1,
                              ), // خلفية شفافة ناعمة
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // حواف ناعمة
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2), // حد خفيف
                              ),
                            ),
                            child: Text(
                              AppString.schoolAccountNote,
                              textAlign: TextAlign.center,
                              style: context.bodyMedium?.copyWith(
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: sizer.h(20)),

                        RowDividerTextDivider(text: AppString.supportText),

                        GestureDetector(
                          onTap: () {
                            controllerSupport.openWhatsApp();
                          },
                          child: Image.asset(
                            'assets/images/wapp.png',
                            width: sizer.w(40),
                            height: sizer.h(40),
                            fit: BoxFit.contain,
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
