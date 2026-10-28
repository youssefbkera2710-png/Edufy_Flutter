import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class AddExamSectionCard extends StatelessWidget {
  final String title;
  final IconData titleIcon;
  final List<Widget> children;

  const AddExamSectionCard({
    super.key,
    required this.title,
    required this.titleIcon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Container(
        padding: EdgeInsets.all(sizer.w(16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sizer.radius(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(titleIcon, size: sizer.w(24)),
                SizedBox(width: sizer.w(8)),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            SizedBox(height: sizer.h(8)),
            ...children,
          ],
        ),
      ),
    );
  }
}
