import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class DescriptionCard extends StatelessWidget {
  const DescriptionCard({super.key, required this.description, this.isHomeWork});

  final String description;
  final bool? isHomeWork;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ResponsiveWidget(
      builder: (sizer) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sizer.radius(20)),
          border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          color: theme.cardTheme.color,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: sizer.w(16),
          vertical: sizer.h(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(isHomeWork == true)
            Row(
              children: [
                Icon(
                  Icons.description_outlined, 
                  size: sizer.w(20),
                  color: theme.iconTheme.color,
                ),
                SizedBox(width: sizer.w(8)),
                Text(
                  'الوصف',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: sizer.h(8)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: sizer.w(12),
                vertical: sizer.h(12),
              ),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(sizer.radius(12)),
                border: isHomeWork == true 
                    ? Border.all(color: theme.dividerColor.withOpacity(0.3)) 
                    : null,
              ),
              child: Text(
                description, 
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}