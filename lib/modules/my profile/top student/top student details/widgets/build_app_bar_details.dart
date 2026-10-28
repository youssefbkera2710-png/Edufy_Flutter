import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/top_student.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class BuildAppBarDetails extends StatelessWidget {
  const BuildAppBarDetails({super.key, required this.student});
  final TopStudent student;
  @override
  Widget build(BuildContext context) {
    final hasImage = student.image != null && student.image!.trim().isNotEmpty;

    return ResponsiveWidget(
      builder: (sizer) => SliverAppBar(
        expandedHeight: sizer.h(200),
        pinned: true,
        backgroundColor: context.primary,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin:  EdgeInsets.symmetric(horizontal: sizer.w(10), vertical: sizer.h(10)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sizer.radius(8)),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: context.white,
              size: sizer.w(18),
            ),
          ),
        ),
        title:  Text(
          'بيانات الطالب',
          style:context.bodyLarge!.copyWith(color: context.white,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                colors: [context.primary, context.primary.withOpacity(0.5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Padding(
                padding:  EdgeInsets.only(top: sizer.h(60)),
                child: Container(
                  width: sizer.w(110),
                  height: sizer.h(110),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: context.white, width: sizer.w(3)),
                    color: context.white.withOpacity(0.2),
                  ),
                  child: ClipOval(
                    child: hasImage
                        ? Image.network(
                            student.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => defaultIcon(context),
                          )
                        : defaultIcon(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget defaultIcon(BuildContext context) =>
      Icon(Icons.person, size: 60, color: context.primary);
}
