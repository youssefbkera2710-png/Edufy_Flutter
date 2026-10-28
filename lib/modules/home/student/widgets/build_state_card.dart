import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class BuildStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String badge;
  final Color badgeColor;
  final VoidCallback? onTap;

  const BuildStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.badge,
    required this.badgeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();

    return ResponsiveWidget(
      builder: (sizer) => InkWell(
        borderRadius: BorderRadius.circular(sizer.radius(16)),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: sizer.w(14),
            vertical: sizer.h(14),
          ),
          decoration: BoxDecoration(
            color: theme.isDarkMode.value == true
                ? context.primaryColorMode
                : context.white,
            borderRadius: BorderRadius.circular(sizer.radius(16)),
            boxShadow: [
              BoxShadow(
                color: context.black2.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizer.w(8),
                      vertical: sizer.h(3),
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(sizer.radius(6)),
                    ),
                    child: Text(
                      badge,
                      style: context.bodySmall!.copyWith(
                        color: badgeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(icon, color: iconColor, size: sizer.w(25)),
                ],
              ),
              SizedBox(height: sizer.h(10)),
              Text(
                value,
                style: context.bodyExtraLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: sizer.w(24),
                ),
              ),
              SizedBox(height: sizer.h(2)),
              Text(label, style: context.bodySmall!.copyWith()),
            ],
          ),
        ),
      ),
    );
  }
}
