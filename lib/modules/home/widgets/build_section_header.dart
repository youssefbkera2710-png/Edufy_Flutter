import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class BuildSectionHeader extends StatelessWidget {
  const BuildSectionHeader({
    super.key,
    this.action,
    required this.title,
    required this.icon,
    this.onTap,
    this.isHomework,
  });
  final String? action;
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool? isHomework;
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Directionality(
        textDirection: isHomework == true
            ? TextDirection.ltr
            : TextDirection.ltr,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sizer.w(16)),
          child: Row(
            children: [
              action != null
                  ? InkWell(
                      borderRadius: BorderRadius.circular(sizer.radius(4)),
                      onTap: onTap,
                      child: Text(
                        action!,
                        style: context.bodyMedium?.copyWith(
                          color: context.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              const Spacer(),
              Text(
                title,
                style: isHomework == true
                    ? context.bodyMedium!.copyWith(fontWeight: FontWeight.bold)
                    : context.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: sizer.w(8)),
              Icon(
                icon,
                color: context.primary,
                size: isHomework == true ? sizer.w(20) : sizer.w(25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
