import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'news_controller.dart';

class NewsDetailsScreen extends StatefulWidget {
  const NewsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  final NewsController controller = Get.find<NewsController>();

  @override
  void initState() {
    super.initState();
    final int newsId = Get.arguments;
    controller.fetchNewsDetails(newsId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Obx(() {
        if (controller.isLoadingDetails.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(context.theme.primaryColor),
            ),
          );
        }

        final news = controller.newsDetailsData.value;

        if (news == null) {
          return Center(
            child: Text(
              "فشل في جلب تفاصيل الخبر",
              style: TextStyle(color: context.theme.disabledColor),
            ),
          );
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                stretch: true,
                backgroundColor: context.theme.scaffoldBackgroundColor,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        (news.image != null && news.image!.isNotEmpty)
                            ? news.image!
                            : 'https://via.placeholder.com/600x400?text=No+Image',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: context.theme.disabledColor.withOpacity(0.1),
                          child: Icon(Icons.broken_image_rounded, size: 60, color: context.theme.disabledColor),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.1),
                              Colors.transparent,
                              context.theme.scaffoldBackgroundColor.withOpacity(0.85),
                              context.theme.scaffoldBackgroundColor,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.0, 0.3, 0.5, 0.9, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: context.theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            news.category ?? 'عام',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: context.theme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: context.theme.disabledColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month_rounded, size: 14, color: context.theme.disabledColor),
                              const SizedBox(width: 6),
                              Text(
                                news.publishDate ?? '',
                                style: TextStyle(fontSize: 11, color: context.theme.disabledColor, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: context.theme.disabledColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.visibility_rounded, size: 14, color: context.theme.disabledColor),
                              const SizedBox(width: 6),
                              Text(
                                "${news.views ?? 0}",
                                style: TextStyle(fontSize: 11, color: context.theme.disabledColor, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      news.title ?? '',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: context.theme.textTheme.titleLarge?.color,
                        height: 1.4,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: context.theme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: context.theme.disabledColor.withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        news.summary ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: context.theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      news.content ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: context.theme.textTheme.bodyLarge?.color?.withOpacity(0.85),
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 50),
                  ]),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}