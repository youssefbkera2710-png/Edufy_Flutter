import 'package:edufy/models/children.dart';
import 'package:edufy/modules/home/guardian/widgets/profile_card.dart';
import 'package:edufy/modules/home/guardian/widgets/requests_for_excuses_card.dart';
import 'package:edufy/modules/home/guardian/widgets/section_card.dart';
import 'package:edufy/modules/home/guardian/widgets/son_data.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class ChildDetailsScreen extends StatelessWidget {
  const ChildDetailsScreen({super.key, required this.child});
  final Children child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الابن ')),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return ResponsiveWidget(
            builder: (sizer) => SingleChildScrollView(
              padding: EdgeInsets.all(sizer.w(16)),
              child: Column(
                children: [
                  // ──  الملف الشخصي ─────────────────────────────────────
                  ProfileCard(
                    user: child.user!,
                    currentClass: child.currentClass,
                  ),
                  SizedBox(height: sizer.h(16)),

                  // ── بيانات الابن ──────────────────────────────────────
                  SectionCard(
                    title: 'بيانات الابن',
                    titleIcon: Icons.assignment_ind_outlined,
                    child: SonData(
                      studentName: child.user!.name!,
                      studentId: child.id!,
                    ),
                  ),
                  SizedBox(height: sizer.h(16)),

                  // ── طلبات الأعذار ─────────────────────────────────────
                  SectionCard(
                    title: 'طلبات الأعذار',
                    titleIcon: Icons.report_problem_outlined,
                    child: RequestsForExcusesCard(
                      studentName: child.user!.name!,
                      studentId: child.id!,
                    ),
                  ),
                  SizedBox(height: sizer.h(16)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
