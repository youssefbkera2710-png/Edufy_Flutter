import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'news_controller.dart';
import 'news_details_screen.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewsController controller = Get.put(NewsController());

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "أخبار المدرسة",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: context.theme.textTheme.titleLarge?.color,
          ),
        ),
        elevation: 0,
        backgroundColor: context.primary,
        iconTheme: context.theme.iconTheme,
      ),
      body: Obx(() {
        if (controller.isLoadingList.value) {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: 3,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              height: 280,
              decoration: BoxDecoration(
                color: context.theme.disabledColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }

        if (controller.newsList.isEmpty) {
          return NoDataWidget(
            message: "لا يوجد أخبار منشورة حالياً",
            icon: Icons.newspaper_rounded,
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchInitialNews(),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              controller: controller.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              itemCount: controller.newsList.length + 1,
              itemBuilder: (context, index) {
                if (index == controller.newsList.length) {
                  return Obx(
                    () => controller.isLoadingMore.value
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  context.theme.primaryColor,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  );
                }

                final item = controller.newsList[index];

                return GestureDetector(
                  onTap: () {
                    if (item.id != null) {
                      Get.to(
                        () => const NewsDetailsScreen(),
                        arguments: item.id,
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: context.theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 180,
                            width: double.infinity,
                            color: context.theme.primaryColor.withOpacity(0.04),
                            child: Image.network(
                              item.image ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.broken_image_rounded,
                                    color: context.theme.disabledColor,
                                    size: 40,
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context.theme.primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        item.category ?? 'عام',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: context.theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_rounded,
                                          size: 14,
                                          color: context.theme.disabledColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          item.publishDate ?? '',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: context.theme.disabledColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item.title ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: context
                                        .theme
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.summary ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: context
                                        .theme
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withOpacity(0.7),
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
