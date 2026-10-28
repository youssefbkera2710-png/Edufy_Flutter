import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final IconData titleIcon;
  final Widget child;

  const SectionCard({
    required this.title,
    required this.titleIcon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sizer.radius(16)),
          border: Border.all(color: context.primary),
          boxShadow: [
            BoxShadow(
              color: context.black2.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: context.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                   SizedBox(width: sizer.w(8)),
                  Icon(titleIcon, color: context.primary, size: sizer.w(20)),
                ],
              ),
            ),
             Divider(height: sizer.h(1),color: context.primary,),
            child,
          ],
        ),
      ),
    );
  }
}
