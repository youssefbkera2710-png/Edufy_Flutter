import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/teacher_statistics.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class TodayTimeTable extends StatelessWidget {
  const TodayTimeTable({super.key, required this.sessions});
  final List<TodayTimetable> sessions;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Padding(
        padding: EdgeInsets.symmetric(horizontal: sizer.w(16)),
        child: Column(
          children: sessions
              .map(
                (s) => Padding(
                  padding: EdgeInsets.only(bottom: sizer.h(12)),
                  child: TimetableRow(session: s,sizer: sizer),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class TimetableRow extends StatelessWidget {
  const TimetableRow({super.key, required this.session, required this.sizer});
  final TodayTimetable session;
  final Sizer sizer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sizer.radius(16)),
        border: Border(right: BorderSide(color: context.primary, width: sizer.w(4))),
      ),
      padding:  EdgeInsets.all(sizer.w(12)),
      child: Row(
        children: [
         
          Container(
            width: sizer.w(72),
            padding:  EdgeInsets.symmetric(vertical: sizer.h(7), horizontal: sizer.w(4)),
            decoration: BoxDecoration(
              color: context.primary.withOpacity(0.18),
              borderRadius: BorderRadius.circular(sizer.radius(12)),
            ),
            child: Column(
              children: [
                Text(
                  session.startTime ?? '--',
                  style: context.bodyMedium!.copyWith(
                    color: context.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'صباحاً',
                  style: context.bodySmall!.copyWith(color: context.primary),
                ),
              ],
            ),
          ),
           SizedBox(width: sizer.w(12)),
        
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.subjectName ?? '-',
                  style: context.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'شعبة ${session.divisionNumber ?? '-'} | ${session.room ?? '-'}',
                  style: context.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
