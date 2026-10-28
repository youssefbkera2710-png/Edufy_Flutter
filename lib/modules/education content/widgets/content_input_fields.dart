import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class ContentInputFields extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController bodyCtrl;
  const ContentInputFields({super.key, required this.titleCtrl, required this.bodyCtrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? context.white : context.grey900;
    final labelColor = isDark ? context.grey150 : context.grey750;

    return Column(
      children: [
        TextField(
          controller: titleCtrl,
          textDirection: TextDirection.rtl,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            labelText: "عنوان المحتوى",
            labelStyle: TextStyle(color: labelColor),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: bodyCtrl,
          textDirection: TextDirection.rtl,
          maxLines: 3,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            labelText: "الوصف والتفاصيل",
            labelStyle: TextStyle(color: labelColor),
          ),
        ),
      ],
    );
  }
}