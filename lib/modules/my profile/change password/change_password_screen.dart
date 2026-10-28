import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/progress_def.dart';
import 'package:edufy/core/shared/widgets/snackbar_def.dart';
import 'package:edufy/modules/auth/widgets/text_form_field_password_def.dart';
import 'package:edufy/core/shared/widgets/elevated_button_def.dart';

import '../../../core/res/validator_def.dart';
import 'change_password_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePasswordController controller = Get.put(
    ChangePasswordController(),
  );

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تحديث كلمة المرور"),
        backgroundColor: context.primary,
      ),
      body: ResponsiveWidget(
        builder: (sizer) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: sizer.w(30)),
            child: Column(
              children: [
                SizedBox(height: sizer.h(20)),

                Icon(
                  Icons.lock_outline,
                  size: sizer.w(80),
                  color: context.primary,
                ),

                SizedBox(height: sizer.h(10)),
                Text(
                  "تحديث كلمة المرور",
                  style: context.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.primary,
                  ),
                ),

                SizedBox(height: sizer.h(30)),

                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormFielPassword(
                        controller: oldPasswordController,
                        label: "كلمة المرور الحالية",
                        paddingTop: sizer.h(10),
                        validator: (p0) => ValidatorDef.validatorPassword(p0),
                      ),

                      SizedBox(height: sizer.h(15)),

                      /// New Password
                      TextFormFielPassword(
                        controller: newPasswordController,
                        label: "كلمة المرور الجديدة",
                        paddingTop: sizer.h(10),
                        validator: (p0) => ValidatorDef.validatorPassword(p0),
                      ),

                      SizedBox(height: sizer.h(15)),

                      /// Confirm Password
                      TextFormFielPassword(
                        controller: confirmPasswordController,
                        label: "تأكيد كلمة المرور",
                        paddingTop: sizer.h(10),
                        validator: (p0) =>
                            ValidatorDef.validatorConfirmPassword(
                              p0,
                              newPasswordController.text,
                            ),
                      ),
                      SizedBox(height: sizer.h(25)),

                      /// Submit Button
                      ElevatedButtonDef(
                        text: "حفظ التغيير",
                        press: () async {
                          if (formKey.currentState!.validate()) {
                            controller.oldPassword = oldPasswordController.text;
                            controller.newPassword = newPasswordController.text;
                            controller.confirmNewPassword =
                                confirmPasswordController.text;

                            progressDef(context);

                            final result = await controller.changePassword();

                            Get.back();

                            if (result != null && result.status == 200) {
                              Get.back();
                              snackBarDef(
                                "نجاح",
                                result.message ?? "تم تحديث كلمة المرور بنجاح",
                              );
                            } else {
                              snackBarDef(
                                "خطأ",
                                result?.message ?? "حدث خطأ غير متوقع",
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
