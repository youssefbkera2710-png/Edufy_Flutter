import 'package:edufy/core/config/user_info.dart';
import 'package:edufy/core/shared/managers/themes_manager/themes_manager.dart';
import 'package:edufy/modules/education%20content/education_content_controller.dart';
import 'package:edufy/modules/education%20content/widgets/educational_content_card.dart';
import 'package:edufy/modules/education%20content/widgets/educations_header.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EducationContentScreen extends StatelessWidget {
  const EducationContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EducationalContentController());
    final homeController = Get.find<HomeController>();
    final colors = ColorManager.of(context).dynamicColors;

    final ScrollController mainScrollController = ScrollController();

    mainScrollController.addListener(() {
      if (mainScrollController.position.pixels >=
          mainScrollController.position.maxScrollExtent - 200) {
        controller.getAllContents();
      }
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight),
          child: Column(
            children: [
              const EducationsHeader(),

              UserInfo.role != 'guardian'
                  ? const SizedBox()
                  : (homeController.children.isEmpty
                        ? const SizedBox.shrink()
                        : Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: homeController.children.length,
                              itemBuilder: (context, index) {
                                final child = homeController.children[index];

                                return Obx(() {
                                  final bool isSelected =
                                      controller.selectedChildId.value ==
                                      child.id;

                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: ChoiceChip(
                                      label: Text(child.user?.name ?? 'إبن'),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        if (selected) {
                                          controller.selectChild(child.id!);
                                        }
                                      },
                                      selectedColor: colors.primary,
                                      labelStyle: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : colors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                          )),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(color: colors.primary),
                    );
                  }
                  if (controller.contentList.isEmpty) {
                    return const Center(
                      child: Text("لا يوجد محتوى متاح حالياً"),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => controller.getAllContents(isRefresh: true),
                    child: ListView.separated(
                      controller: mainScrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          controller.contentList.length +
                          (controller.isLoadingMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.contentList.length) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      color: colors.primary,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "جاري تحميل المزيد من المحتوى...",
                                    style: TextStyle(
                                      color: colors.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return EducationalContentCard(
                          education: controller.contentList[index],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
