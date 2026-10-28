import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';

import 'package:edufy/models/teacher_statistics.dart';
import 'package:responsive_s/responsive_s.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, this.summary});

  final Summary? summary;

  @override
  Widget build(BuildContext context) {
    final items = [
      SI('${summary?.assignedSubjectsCount ?? 0}', 'مادة مسندة'),
      SI('${summary?.assignedClassesCount ?? 0}', 'صفاً مسنداً'),
      SI('${summary?.studentsCount ?? 0}', 'طالباً'),
      SI('${summary?.todaySessionsCount ?? 0}', 'حصة اليوم'),
      SI('${summary?.upcomingExamsCount ?? 0}', 'اختباراً قادماً'),
    ];

    return ResponsiveWidget(
      builder: (sizer) => SizedBox(
        height: sizer.h(120),
        child: ListView.separated(
          reverse: true,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: sizer.w(16),
            vertical: sizer.h(8),
          ),
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(width: sizer.w(12)),
          itemBuilder: (_, i) => SummaryCardItem(item: items[i], sizer: sizer),
        ),
      ),
    );
  }
}

class SI {
  final String value;
  final String label;
  const SI(this.value, this.label);
}

class SummaryCardItem extends StatelessWidget {
  const SummaryCardItem({super.key, required this.item, required this.sizer});
  final SI item;
  final Sizer sizer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizer.w(158),
      padding:  EdgeInsets.all(sizer.w(12)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sizer.radius(16)),
        border: Border.all(color: context.primary, width: sizer.w(2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.value,
            style: context.bodyExtraLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: context.primary,
            ),
          ),
           SizedBox(height: sizer.h(4)),
          Text(item.label, style: context.bodyMedium),
        ],
      ),
    );
  }
}
