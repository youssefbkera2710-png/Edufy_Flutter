import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/managers/themes_manager/themes_manager.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/string_text.dart';

class EmptyScheduleState extends StatelessWidget {
  const EmptyScheduleState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager.of(context).dynamicColors;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(24.0),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(22.0),
          border: Border.all(
            color: colors.primary.withOpacity(0.15),
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_busy_rounded,
              size: 48.0,
              color: colors.primary.withOpacity(0.85),
            ),
            const SizedBox(height: 12.0),
            Text(
              AppString.noSchedule,
              style: context.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: colors.grey900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}