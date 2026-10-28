import 'package:edufy/core/config/user_info.dart';
import 'package:edufy/core/constants/string_text.dart';
import 'package:edufy/modules/my%20profile/my_profile_controller.dart';
import 'package:edufy/modules/my%20profile/top%20student/top_student_screen.dart';
import 'package:edufy/modules/my%20profile/widget/wave_appBar_profile.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/shared/extensions/context_extension.dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({super.key});
  final myProfileController = Get.put(MyProfileController());

  void openPrivacyPolicy() async {
    final Uri privacyUrl = Uri.parse('https://edufy.com/privacy-policy');

    try {
      await launchUrl(privacyUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error opening privacy policy: $e');
      Get.snackbar(
        'خطأ',
        'لا يمكن فتح الرابط',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: waveAppBarProfile(context, AppString.profile),
      body: ResponsiveWidget(
        builder: (sizer) => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sizer.w(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: sizer.h(12)),

                /// ===== الحساب =====
                _sectionTitle(context, "الحساب"),
                SizedBox(height: sizer.h(10)),

                _cardContainer(
                  context,
                  sizer,
                  children: [
                    _itemTile(
                      context,
                      sizer,
                      title: "تعديل الملف الشخصي",
                      subtitle: "حدّث معلوماتك الشخصية",
                      icon: FluentIcons.person_12_filled,
                      onTap: () {
                        Get.toNamed('/editProfile');
                      },
                    ),
                    _divider(),
                    _itemTile(
                      context,
                      sizer,
                      title: "كلمة المرور",
                      subtitle: "تحديث كلمة المرور في حالة نسيانها",
                      icon: FluentIcons.password_20_filled,
                      onTap: () {
                        Get.toNamed('/changePassword');
                      },
                    ),
                  ],
                ),

                SizedBox(height: sizer.h(20)),
                _sectionTitle(context, "الطلاب المميزين"),
                SizedBox(height: sizer.h(10)),

                _cardContainer(
                  context,
                  sizer,
                  children: [
                    _itemTile(
                      context,
                      sizer,
                      title: "عرض الطلاب المميزين ",
                      subtitle: "افضل طلاب في المدرسة",
                      icon: FluentIcons.password_20_filled,
                      onTap: () {
                        Get.to(TopStudentsScreen());
                      },
                    ),
                  ],
                ),

                SizedBox(height: sizer.h(20)),
                if (UserInfo.role == 'student') ...[
                  _sectionTitle(context, "المسيرة التعليمية"),
                  SizedBox(height: sizer.h(10)),

                  _cardContainer(
                    context,
                    sizer,
                    children: [
                      _itemTile(
                        context,
                        sizer,
                        title: "سجل الصفوف للطالب",
                        subtitle: "تصفح الصفوف السابقة والحالي للطالب",
                        icon: Icons.class_,
                        onTap: () {
                          Get.toNamed('/classHistoryScreen');
                        },
                      ),
                      _divider(),
                      _itemTile(
                        context,
                        sizer,
                        title: "سجل الدرجات للطالب ",
                        subtitle: "تصفح السجل العام لدرجات الطالب ",
                        icon: Icons.score_sharp,
                        onTap: () {
                          Get.toNamed("/gradeScreen");
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: sizer.h(20)),
                ],

                _sectionTitle(context, "الوسائط والمعارض"),
                SizedBox(height: sizer.h(10)),

                _cardContainer(
                  context,
                  sizer,
                  children: [
                    _itemTile(
                      context,
                      sizer,
                      title: "معرض الصور والأنشطة",
                      subtitle: "تصفح ألبومات الصور والفعاليات المدرسية",
                      icon: Icons.collections_bookmark_rounded,
                      onTap: () {
                        Get.toNamed('/galleriesListScreen');
                      },
                    ),
                    _divider(),
                    _itemTile(
                      context,
                      sizer,
                      title: "أخبار المدرسة",
                      subtitle:
                          "تابع آخر الأخبار والفعاليات والتعاميم المدرسية",
                      icon: Icons.newspaper_rounded,
                      onTap: () {
                        Get.toNamed('/newsListScreen');
                      },
                    ),
                  ],
                ),
                SizedBox(height: sizer.h(20)),

                _sectionTitle(context, "المساعدة والدعم"),
                SizedBox(height: sizer.h(10)),
                _cardContainer(
                  context,
                  sizer,
                  children: [
                    _itemTile(
                      context,
                      sizer,
                      title: "! Edufy حول",
                      subtitle: " اعرف المزيد عنا",
                      icon: Icons.aod_rounded,
                      onTap: () {},
                    ),
                    _divider(),
                    _itemTile(
                      context,
                      sizer,
                      title: "سياسة الخصوصية",
                      subtitle: "الاطلاع على سياسة الخصوصية",
                      icon: Icons.policy,
                      onTap: () {
                        openPrivacyPolicy();
                      },
                    ),
                  ],
                ),
                SizedBox(height: sizer.h(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ===== Section Title =====
  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  /// ===== Card Container =====
  Widget _cardContainer(
    BuildContext context,
    Sizer sizer, {
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.background.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  /// ===== Item Tile =====
  Widget _itemTile(
    BuildContext context,
    Sizer sizer, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: sizer.w(15),
        vertical: sizer.h(8),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: context.primary),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      leading: Container(
        padding: EdgeInsets.all(sizer.w(10)),
        decoration: BoxDecoration(
          color: context.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: context.primary),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Colors.cyan.withOpacity(0.2),
    );
  }
}
