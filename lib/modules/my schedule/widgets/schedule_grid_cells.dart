import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/managers/themes_manager/themes_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class GridHeaderCell extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final bool isMain;

  const GridHeaderCell({
    super.key,
    required this.title,
    required this.width,
    required this.height,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager.of(context).dynamicColors;
    final isDark = context.isDarkMode;

    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(3.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isMain
            ? colors.primary
            : (isDark ? colors.grey150.withOpacity(0.1) : colors.white),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isMain ? colors.primary : colors.grey150.withOpacity(0.5),
          width: 1.0,
        ),
      ),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.bodySmall?.copyWith(
          fontWeight: FontWeight.w900,
          color: isMain
              ? colors.white
              : (isDark ? colors.white : colors.grey900),
        ),
      ),
    );
  }
}

class GridDayCell extends StatelessWidget {
  final String title;
  final bool isToday;
  final bool isSelected;
  final double width;
  final double height;

  const GridDayCell({
    super.key,
    required this.title,
    required this.isToday,
    required this.isSelected,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager.of(context).dynamicColors;
    final isDark = context.isDarkMode;

    final bg = isSelected
        ? colors.primary
        : isToday
        ? colors.primary.withOpacity(0.16)
        : (isDark ? colors.grey150.withOpacity(0.05) : colors.white);

    final border = isSelected
        ? colors.primary
        : isToday
        ? colors.primary.withOpacity(0.45)
        : colors.grey150.withOpacity(0.5);

    final textColor = isSelected
        ? colors.white
        : (isDark ? colors.white : colors.grey900);

    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(3.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: border, width: isSelected ? 1.5 : 1.0),
      ),
      child: Text(
        isToday ? '$title\nاليوم' : title,
        textAlign: TextAlign.center,
        style: context.bodySmall?.copyWith(
          height: 1.2,
          fontWeight: FontWeight.w900,
          color: textColor,
          fontSize: 12,
        ),
      ),
    );
  }
}

class GridSubjectCell extends StatelessWidget {
  final String subject;
  final bool isToday;
  final bool isSelected;
  final Color accent;
  final double width;
  final double height;
  final int? divisionNumber;

  const GridSubjectCell({
    super.key,
    required this.subject,
    required this.isToday,
    required this.isSelected,
    required this.accent,
    required this.width,
    required this.height,
    this.divisionNumber,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager.of(context).dynamicColors;
    final isDark = context.isDarkMode;
    final hasData = subject.trim().isNotEmpty;

    final bg = isSelected
        ? accent.withOpacity(0.24)
        : isToday
        ? accent.withOpacity(0.16)
        : hasData
        ? accent.withOpacity(0.18)
        : (isDark ? colors.grey150.withOpacity(0.05) : colors.grey50);

    final border = isSelected
        ? accent
        : isToday
        ? accent.withOpacity(0.55)
        : hasData
        ? accent.withOpacity(0.45)
        : colors.grey150.withOpacity(0.5);

    final textColor = hasData
        ? (isDark ? Colors.white : accent)
        : (isDark ? colors.grey350 : colors.grey625);

    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(3.0),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: border, width: isSelected ? 1.35 : 1.0),
      ),
      child: Text(
        divisionNumber != null ? subject + divisionNumber.toString() : subject,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: context.bodySmall?.copyWith(
          height: 1.2,
          fontWeight: FontWeight.w900,
          color: textColor,
          fontSize: 11,
        ),
      ),
    );
  }
}
