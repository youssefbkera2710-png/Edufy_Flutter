import 'package:edufy/components/AppSkeletonList.dart';
import 'package:edufy/core/shared/controller/theme_controller.dart';
import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:edufy/modules/class/class_controller.dart';
import 'package:edufy/modules/class/widget/info_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

import '../../../core/shared/extensions/context_extension.dart';

class ClassScreen extends StatelessWidget {
  ClassScreen({super.key});

  final ClassController controller = Get.put(ClassController());
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل الصفوف"),
        backgroundColor: context.primary,
      ),

      body: ResponsiveWidget(
        builder: (sizer) => Obx(() {
          if (controller.isLoading.value) {
            return const AppSkeletonList(itemCount: 8, itemHeight: 160);
          }
          if (controller.classes.isEmpty) {
            return NoDataWidget(
              message: 'لا يوجد سجل صفوف حاليا',
              icon: Icons.bookmark_outlined,
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await controller.getData();
            },

            child: ListView.builder(
              padding: EdgeInsets.all(sizer.w(20)),
              itemCount: controller.classes.length,

              itemBuilder: (context, index) {
                final item = controller.classes[index];

                return Container(
                  margin: EdgeInsets.only(bottom: sizer.h(18)),

                  padding: EdgeInsets.all(sizer.w(18)),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: themeController.isDarkMode.value
                        ? Color(0xff121314)
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: context.primary.withOpacity(0.09),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(sizer.w(10)),

                            decoration: BoxDecoration(
                              color: context.primary.withOpacity(.1),

                              borderRadius: BorderRadius.circular(14),
                            ),

                            child: Icon(Icons.school, color: context.primary),
                          ),

                          SizedBox(width: sizer.w(12)),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  item.className ?? "غير معروف",

                                  style: context.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: sizer.h(6)),

                                Text(
                                  controller.stageText(item.stage ?? ""),

                                  style: context.bodySmall,
                                ),
                              ],
                            ),
                          ),

                          if (item.isCurrent == true)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: sizer.w(12),
                                vertical: sizer.h(6),
                              ),

                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(.12),

                                borderRadius: BorderRadius.circular(30),
                              ),

                              child: Text(
                                "الحالي",

                                style: context.bodySmall?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: sizer.h(22)),

                      Row(
                        children: [
                          Expanded(
                            child: InfoCardWidget(
                              context,
                              title: "السنة الدراسية",
                              value: item.academicYear ?? "-",
                              icon: Icons.calendar_month,
                            ),
                          ),

                          SizedBox(width: sizer.w(14)),

                          Expanded(
                            child: InfoCardWidget(
                              context,
                              title: "الفصل",
                              value: controller.semesterText(
                                item.semester ?? "",
                              ),
                              icon: Icons.menu_book,
                              valueColor: controller.semesterColor(
                                item.semester ?? "",
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: sizer.h(18)),

                      Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(sizer.w(14)),

                        decoration: BoxDecoration(
                          color: context.primary,

                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Row(
                          children: [
                            const Icon(Icons.date_range, color: Colors.white),

                            SizedBox(width: sizer.w(10)),

                            Expanded(
                              child: Text(
                                item.startDate != null
                                    ? "تاريخ البداية : ${item.startDate.toString().split(" ")[0]}"
                                    : "لا يوجد تاريخ",

                                style: context.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
