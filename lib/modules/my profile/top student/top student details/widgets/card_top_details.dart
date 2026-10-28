import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class CardTopDetails extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const CardTopDetails({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    return ResponsiveWidget(
      builder: (sizer) => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: sizer.w(18), vertical: sizer.h(18)),
        decoration: BoxDecoration(
          color:theme.isDarkMode.value == true ? context.black2 : context.white,
          borderRadius: BorderRadius.circular(sizer.radius(20)),
          boxShadow: [
            BoxShadow(
              color: context.black2.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: context.primary, size: sizer.w(20)),
                 SizedBox(width: sizer.w(8)),
                Text(
                  title,
                  style: context.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}
