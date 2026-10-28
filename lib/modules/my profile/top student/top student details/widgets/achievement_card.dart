import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/top_student.dart';
import 'package:edufy/modules/my%20profile/top%20student/top%20student%20details/widgets/card_top_details.dart';
import 'package:edufy/modules/my%20profile/top%20student/top%20student%20details/widgets/info_row_details.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class AchievementCard extends StatelessWidget {
  final TopStudent student;
  const AchievementCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => CardTopDetails(
        title: 'الإنجاز',
        icon: Icons.emoji_events_outlined,
        children: [
          Container(
            width: double.infinity,
            padding:  EdgeInsets.symmetric(horizontal: sizer.w(14), vertical: sizer.h(14)),
            decoration: BoxDecoration(
              gradient:  LinearGradient(
                colors: [context.white, context.primary.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(sizer.radius(14)),
            ),
            child: Row(
              children: [
                 Icon(Icons.star, color: Colors.amber, size: sizer.w(32)),
                SizedBox(width: sizer.w(12)),
                Expanded(
                  child: Text(
                    student.achievement ?? 'غير محدد',
                    style: context.bodyMedium!.copyWith(fontWeight: FontWeight.bold)
                  ),
                ),
              ],
            ),
          ),
           SizedBox(height: sizer.h(12)),
          InfoRowDetails(
            label: 'ترتيب العرض',
            value: '${student.showOrder ?? 0}',
          ),
        ],
      ),
    );
  }
}
