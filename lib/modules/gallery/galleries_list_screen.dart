import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'gallery_controller.dart';

class GalleriesListScreen extends StatefulWidget {
  const GalleriesListScreen({Key? key}) : super(key: key);

  @override
  State<GalleriesListScreen> createState() => _GalleriesListScreenState();
}

class _GalleriesListScreenState extends State<GalleriesListScreen> {
  final GalleryController controller = Get.put(GalleryController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        controller.fetchMoreGalleries();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("معارض الأنشطة والفعاليات"),
        backgroundColor: context.primary,
      ),
      body: Obx(() {
        if (controller.isLoadingAll.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.allGalleries.isEmpty) {
          return NoDataWidget(
            message: "لا توجد معارض صور متاحة حالياً",
            icon: Icons.picture_in_picture_alt_sharp,
          );
        }
        return SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.allGalleries.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  final gallery = controller.allGalleries[index];

                  return Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    color: context.theme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: context.theme.disabledColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (gallery.id != null) {
                          controller.fetchGalleryDetails(gallery.id!);
                          Get.toNamed(
                            '/galleryDetailsScreen',
                            arguments: gallery.id,
                          );
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. صورة الغلاف للمعرض داخل الشبكة
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: Image.network(
                                  (gallery.coverImage != null &&
                                          gallery.coverImage!.isNotEmpty)
                                      ? gallery.coverImage!
                                      : 'https://via.placeholder.com/400x200?text=No+Cover+Image',
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          color: context.theme.primaryColor
                                              .withOpacity(0.04),
                                          child: const Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        color: context.theme.disabledColor
                                            .withOpacity(0.05),
                                        child: Center(
                                          child: Icon(
                                            Icons.broken_image_rounded,
                                            color: context.theme.disabledColor,
                                            size: 32,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 10.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  gallery.title ?? '',
                                  style: TextStyle(
                                    fontSize: 15,
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
                                const SizedBox(height: 4),
                                Text(
                                  gallery.description ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: context
                                        .theme
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withOpacity(0.6),
                                    height: 1.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              Obx(() {
                return controller.isLoadingMore.value
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.theme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              }),
            ],
          ),
        );
      }),
    );
  }
}
