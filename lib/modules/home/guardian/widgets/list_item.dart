import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class ListItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ListItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => 
      ListTile(
        onTap: onTap,
        contentPadding:  EdgeInsets.symmetric(horizontal: sizer.w(16), vertical: sizer.h(4)),
        leading:  Icon(Icons.chevron_left, color: context.grey625),
        title: Text(
          label,
          style: context.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.right,
        ),
        trailing: Container(
          width: sizer.w(38),
          height: sizer.h(38),
          decoration: BoxDecoration(color: context.primary.withOpacity(0.3), shape: BoxShape.circle),
          child: Icon(icon, color: context.primary, size: sizer.w(20)),
        ),
      ),
    );
  }
}
