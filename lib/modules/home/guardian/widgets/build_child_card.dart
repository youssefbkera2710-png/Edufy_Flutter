import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/children.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';
import 'package:edufy/modules/home/guardian/child_details_screen.dart';

class BuildStudentCard extends StatelessWidget {
  const BuildStudentCard({super.key, required this.child});
  final Children child;
  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();

    return ResponsiveWidget(
      builder: (sizer) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: sizer.w(16),
          vertical: sizer.h(16),
        ),
        decoration: BoxDecoration(
          color: theme.isDarkMode.value == true
              ? Colors.black12
              : context.white,
          borderRadius: BorderRadius.circular(sizer.radius(18)),
          boxShadow: [
            BoxShadow(
              color: context.black2.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            OutlinedButton(
              onPressed: () {
                Get.to(() => ChildDetailsScreen(child: child));
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: context.primary),
                foregroundColor: context.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: sizer.w(14),
                  vertical: sizer.h(8),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sizer.radius(10)),
                ),
                textStyle: context.bodySmall!.copyWith(
                  color: context.primary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              child: const Text('التفاصيل'),
            ),

            const Spacer(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'الطالب',
                  style: context.bodySmall!.copyWith(color: context.lightblue),
                ),
                const SizedBox(height: 2),
                Text(child.user!.name!, style: context.bodyRegular),
                SizedBox(height: sizer.h(2)),
                Text(
                  child.currentClass?.stage ?? '',
                  style: context.bodySmall!.copyWith(color: context.lightblue),
                ),
              ],
            ),
            SizedBox(width: sizer.w(12)),

            Container(
              width: sizer.w(50),
              height: sizer.h(50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: sizer.w(2.5), color: context.white),
              ),
              child: ClipOval(
                child: child.user!.avatar == null
                    ? Image.asset('assets/images/logo.png', fit: BoxFit.cover)
                    : Image.network(child.user!.avatar, fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
