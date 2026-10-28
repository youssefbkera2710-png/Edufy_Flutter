import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';

Widget InfoCardWidget(
  BuildContext context, {
  required String title,
  required String value,
  required IconData icon,
  Color? valueColor,
}) {
  return Container(
    padding: EdgeInsets.all(14),

    decoration: BoxDecoration(
      color: context.primary.withOpacity(.05),

      borderRadius: BorderRadius.circular(16),
    ),

    child: Column(
      children: [
        Icon(icon, color: context.primary),

        SizedBox(height: 10),

        Text(title, style: context.bodySmall),

        SizedBox(height: 8),
        Text(
          value,
          textAlign: TextAlign.center,

          style: context.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    ),
  );
}
