import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'education_details_controller.dart';
import 'widgets/media_carousel_widget.dart';
import 'package:edufy/core/shared/managers/themes_manager/themes_manager.dart';
import 'package:edufy/modules/education%20content/widgets/comments_section.dart';

class EducationalDetailsScreen extends StatelessWidget {
  EducationalDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EducationDetailsController());
    final colors = ColorManager.of(context).dynamicColors;
    final isDark = context.isDarkMode;

    return Obx(() {
      if (controller.isDetailsLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final data = controller.selectedContentDetails.value;
      if (data == null) {
        return Scaffold(
          backgroundColor: isDark ? context.background : colors.white,
          body: const Center(child: Text('لا توجد بيانات')),
        );
      }

      final accentColor = controller.getSubjectColor(context, data.subjectName);

      return Scaffold(
        appBar: AppBar(
          backgroundColor: accentColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            data.title ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                if (data.files != null && data.files!.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: MediaCarouselWidget(
                        mediaList: data.files!,
                        accentColor: accentColor,
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildContentSection(context, data, colors),
                      const SizedBox(height: 150),
                    ]),
                  ),
                ),
              ],
            ),
            _buildCommentSheet(context, controller),
          ],
        ),
      );
    });
  }

  Widget _buildContentSection(
    BuildContext context,
    dynamic data,
    dynamic colors,
  ) {
    final isDark = context.isDarkMode;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? colors.white.withOpacity(0.05) : colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? colors.grey150.withOpacity(0.1) : colors.grey150,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: colors.black2.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined, color: colors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'التفاصيل',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? colors.white : colors.grey900,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  data.teacherName ?? '',
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            data.body ?? '',
            style: TextStyle(
              height: 1.8,
              fontSize: 14,
              color: isDark ? colors.grey150 : colors.grey900.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSheet(
    BuildContext context,
    EducationDetailsController controller,
  ) {
    final colors = ColorManager.of(context).dynamicColors;
    final isDark = context.isDarkMode;

    return DraggableScrollableSheet(
      controller: controller.sheetController,
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 0.9,
      snap: true,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black12,
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: controller.toggleSheet,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.transparent,
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark
                            ? colors.grey350.withOpacity(0.3)
                            : colors.grey150,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "التعليقات",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? colors.white : colors.grey900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                controller: scrollController,
                children: [
                  CommentsSectionWidget(
                    contentId: controller.contentID,
                    allowComments:
                        controller
                            .selectedContentDetails
                            .value
                            ?.allowComments ??
                        false,
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
