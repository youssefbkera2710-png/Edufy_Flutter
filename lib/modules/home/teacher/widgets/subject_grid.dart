import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/teacher_statistics.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class SubjectsGrid extends StatelessWidget {
  const SubjectsGrid({super.key, required this.assignments});
  final List<ClassSubjectAssignment> assignments;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Padding(
        padding: EdgeInsets.symmetric(horizontal: sizer.w(16)),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: assignments.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.8,
          ),
          itemBuilder: (_, i) {
            final item = assignments[i];

            return Container(
              padding: EdgeInsets.all(sizer.h(12)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sizer.radius(16)),
                border: Border.all(color: context.primary),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${item.subjectName}',
                    style: context.bodyMedium!.copyWith(
                      color: context.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${item.className}',
                    style: context.bodySmall!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: sizer.h(1)),
                  Expanded(
                    child: Text(
                      '${item.weeklyHours ?? 0} ساعات أسبوعياً',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
