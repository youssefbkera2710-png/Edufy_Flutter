import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class FieldLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const FieldLabel({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Row(
        children: [
          Icon(icon, size: sizer.w(20), color: context.primary),
          SizedBox(width: sizer.w(8)),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
