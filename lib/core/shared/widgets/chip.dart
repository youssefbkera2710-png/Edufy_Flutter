import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class ChipSubject extends StatelessWidget {
  final String label;
  final IconData? icon;
  final double fontSize;
  final Color? color;

  const ChipSubject({
    super.key,
    required this.label,
    this.icon,
    this.fontSize = 12,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: sizer.w(12),
          vertical: sizer.h(6),
        ),
        decoration: BoxDecoration(
          color: (color ?? context.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(sizer.radius(20)),
          border: Border.all(
            color: (color ?? context.primary).withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: sizer.w(fontSize),
                color: color ?? context.primary,
              ),
              SizedBox(width: sizer.w(4)),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: sizer.w(fontSize),
                fontWeight: FontWeight.w500,
                color: color ?? context.onBackgroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
