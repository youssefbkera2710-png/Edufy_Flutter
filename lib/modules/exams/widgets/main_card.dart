import 'package:edufy/models/teacher_exam.dart';
import 'package:edufy/core/shared/widgets/chip.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class MainCard extends StatelessWidget {
  const MainCard({super.key, required this.exam});

  final Datums exam;

  String get formattedDate {
    final d = exam.examDate;
    if (d == null) return '-';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String get subjectName {
    final assignments = exam.assignments;
    if (assignments == null || assignments.isEmpty) return '-';
    return assignments.first.subjectName ?? '-';
  }

  String get classLabel {
    final assignments = exam.assignments;
    if (assignments == null || assignments.isEmpty) return '-';
    return assignments
        .map((a) => a.className ?? '')
        .where((n) => n.isNotEmpty)
        .join(' ،  ');
  }

  String get maxScore {
    final score = exam.maxScore;
    if (score == null) return '0';
    final doubleValue = double.tryParse(score);
    if (doubleValue == null) return score;
    if (doubleValue == doubleValue.toInt()) {
      return doubleValue.toInt().toString();
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sizer.radius(20)),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          color: Theme.of(context).cardTheme.color,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizer.w(16),
                vertical: sizer.h(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ChipSubject(label: subjectName, fontSize: 14),
                      if (subjectName != '-') SizedBox(width: sizer.w(14)),
                      ChipSubject(
                        label: formattedDate,
                        icon: Icons.calendar_today_rounded,
                        fontSize: 14,
                      ),
                    ],
                  ),

                  SizedBox(height: sizer.h(14)),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          exam.title ?? '-',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: sizer.w(12)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: sizer.w(14),
                          vertical: sizer.h(10),
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(sizer.radius(14)),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'الدرجة القصوى',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            SizedBox(height: sizer.h(4)),
                            Text(
                              maxScore,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onBackground,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizer.w(16),
                vertical: sizer.h(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.groups_2_outlined,
                    size: sizer.w(16),
                    color: Theme.of(context).iconTheme.color,
                  ),
                  SizedBox(width: sizer.w(8)),
                  Expanded(
                    child: Text(
                      classLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
