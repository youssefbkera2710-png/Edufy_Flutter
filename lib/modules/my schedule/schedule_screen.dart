import 'package:edufy/core/shared/managers/themes_manager/themes_manager.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:edufy/modules/my%20schedule/my_schedule_controller.dart';
import 'package:edufy/modules/my%20schedule/widgets/empty_schedule_state.dart';
import 'package:edufy/modules/my%20schedule/widgets/schedule_header.dart';
import 'package:edufy/modules/my%20schedule/widgets/weekly_schedule_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edufy/core/config/user_info.dart';

class ScheduleScreen extends StatelessWidget {
  ScheduleScreen({super.key});

  final ScheduleController controller = Get.put(ScheduleController());
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final colors = ColorManager.of(context).dynamicColors;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: RefreshIndicator(
          color: colors.primary,
          onRefresh: () =>
              controller.getSchedule(childId: controller.selectedChildId.value),
          child: Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: ScheduleHeader(controller: controller),
                ),
                GetBuilder<ScheduleController>(
                  builder: (controller) {
                    if (UserInfo.role != 'guardian' ||
                        homeController.children.isEmpty) {
                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    }
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: homeController.children.length,
                          itemBuilder: (context, index) {
                            final child = homeController.children[index];
                            final bool isSelected =
                                controller.selectedChildId.value == child.id;

                            return Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: ChoiceChip(
                                label: Text(child.user?.name ?? 'إبن'),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected)
                                    controller.selectChild(child.id!);
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
                          },
                        ),
                      ),
                    );
                  },
                ),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (controller.scheduleList.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyScheduleState(),
                    );
                  }

                  return SliverToBoxAdapter(
                    child: WeeklyScheduleGrid(controller: controller),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
