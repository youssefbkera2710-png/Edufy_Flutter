// lib/modules/shared/widgets/date_picker_field.dart
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Rx<DateTime?> selectedDate;
  final String formattedDate;
  final String hintText;

  const DatePickerField({
    super.key,
    required this.label,
    required this.onTap,
    required this.selectedDate,
    required this.formattedDate,
    this.hintText = 'اختر التاريخ',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: context.primary,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    selectedDate.value == null ? hintText : formattedDate,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                ),
                Icon(Icons.calendar_today, color: context.primary, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
