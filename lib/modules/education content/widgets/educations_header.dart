import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/managers/themes_manager/themes_manager.dart';
import 'package:flutter/material.dart';

class EducationsHeader extends StatelessWidget {
  const EducationsHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager.of(context).dynamicColors;

    return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 14.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            colors.primary,
            colors.Turquoise,
            colors.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(28.0),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.24),
            blurRadius: 22.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end, //
              children: [
                Text(
                  "المحتوى التعليمي",
                  style: context.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "استكشف الدروس والملفات المتاحة",
                  style: context.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),

          Container(
            width: 52.0,
            height: 52.0,
            decoration: BoxDecoration(
              color: colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 28.0,
            ),
          ),

        ],
      ),
    );
  }
}