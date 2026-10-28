import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/my%20profile/top%20student/top_student_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class BannerStudent extends StatelessWidget {
  const BannerStudent({super.key});

  String get _month {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return months[DateTime.now().month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Obx(() {
        final controller = Get.find<TopStudentsController>();
        final total = controller.pagination.value?.total;
        return Container(
          margin:  EdgeInsets.symmetric(horizontal: sizer.w(20), vertical: sizer.h(14)),
          padding:  EdgeInsets.symmetric(horizontal: sizer.w(18), vertical: sizer.h(10)),
          decoration: BoxDecoration(
            color: context.primary,
            borderRadius: BorderRadius.circular(sizer.radius(30)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
               Icon(Icons.star, color: Colors.amber, size: sizer.w(20)),
               SizedBox(width: sizer.w(8)),
              Text(
                'تكريم المتفوقين لشهر $_month${total != null ? ' ($total)' : ''}',
                style: context.bodyMedium!.copyWith(color: context.white,fontWeight: FontWeight.w500)
              ),
            ],
          ),
        );
      }),
    );
  }
}
