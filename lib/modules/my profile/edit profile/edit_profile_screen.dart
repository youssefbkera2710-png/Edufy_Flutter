import 'package:cached_network_image/cached_network_image.dart';
import 'package:edufy/core/constants/string_text.dart';
import 'package:edufy/core/res/validator_def.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

import '../../../core/shared/extensions/context_extension.dart';
import '../../../core/shared/widgets/elevated_button_def.dart';
import '../../../core/shared/widgets/progress_def.dart';
import '../../../core/shared/widgets/snackbar_def.dart';
import '../../auth/widgets/text_form_field_def.dart';
import 'edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final EditProfileController controller = Get.put(EditProfileController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تعديل الملف الشخصي"),
        backgroundColor: context.primary,
      ),
      body: ResponsiveWidget(
        builder: (sizer) => RefreshIndicator(
          onRefresh: () async {
            await controller.syncProfile();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sizer.w(30)),
              child: Column(
                children: [
                  SizedBox(height: sizer.h(40)),

                  Obx(
                    () => GestureDetector(
                      onTap: controller.pickImage,
                      child: CircleAvatar(
                        radius: sizer.w(60),
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: SizedBox(
                            width: sizer.w(120),
                            height: sizer.w(120),
                            child: controller.imageFile.value != null
                                ? Image.file(
                                    controller.imageFile.value!,
                                    fit: BoxFit.cover,
                                  )
                                : (controller.avatarUrl.value != null &&
                                      controller.avatarUrl.value.isNotEmpty &&
                                      controller.avatarUrl.value != 'null')
                                ? CachedNetworkImage(
                                    imageUrl: controller.avatarUrl.value!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                          'assets/images/user.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                  )
                                : Image.asset(
                                    'assets/images/user.jpg',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: sizer.h(10)),

                  Text("اضغط لتغيير الصورة", style: context.bodySmall),

                  SizedBox(height: sizer.h(40)),

                  /// 🔥 الفورم
                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormFieldDeF(
                          controller: controller.phoneController,
                          label: "رقم الهاتف",
                          keyboard: TextInputType.phone,
                          paddingTop: sizer.h(10),
                          maxLines: 1,
                          validator: (p0) => ValidatorDef.validatorPhone(p0),
                        ),
                        SizedBox(height: sizer.h(20)),
                        TextFormFieldDeF(
                          controller: controller.nameController,
                          label: "الاسم",
                          paddingTop: sizer.h(10),
                          maxLines: 1,
                          validator: (p0) => ValidatorDef.validatorName(p0),
                          readOnly: true,
                          icon: Icons.lock,
                        ),
                        SizedBox(height: sizer.h(20)),

                        TextFormFieldDeF(
                          controller: controller.emailController,
                          label: "البريد الإلكتروني",
                          paddingTop: sizer.h(10),
                          maxLines: 1,
                          readOnly: true,
                          icon: Icons.lock,
                        ),
                        SizedBox(height: sizer.h(20)),
                        TextFormFieldDeF(
                          controller: controller.createdController,
                          label: "بداية الحساب",
                          paddingTop: sizer.h(10),
                          maxLines: 1,
                          readOnly: true,
                          icon: Icons.lock,
                        ),
                        SizedBox(height: sizer.h(30)),

                        ElevatedButtonDef(
                          press: () async {
                            if (formKey.currentState!.validate()) {
                              progressDef(context);

                              final result = await controller.updateProfile();

                              Get.back();

                              if (result != null && result.status == 200) {
                                Get.back();
                                snackBarDef(
                                  AppString.loginSuccessTitle,
                                  result.message ?? "تم تعديل البيانات",
                                );
                              } else {
                                snackBarDef(
                                  AppString.loginErrorTitle,
                                  result?.message ?? "حدث خطأ غير متوقع",
                                );
                              }
                            }
                          },
                          text: "حفظ التعديلات",
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
