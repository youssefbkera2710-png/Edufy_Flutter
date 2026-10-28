import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'gallery_controller.dart';

class GalleryDetailsScreen extends StatelessWidget {
  const GalleryDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GalleryController controller = Get.find<GalleryController>();

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("معرض الصور والانشظة "),
        backgroundColor: context.primary,
      ),
      body: Obx(() {
        if (controller.isLoadingDetails.value) {
          return _buildShimmerLoading(context);
        }

        final gallery = controller.galleryDetailsData.value;

        if (gallery == null) {
          return _buildEmptyState(
            context: context,
            icon: Icons.cloud_off_rounded,
            message: "فشل في جلب البيانات، يرجى المحاولة لاحقاً",
          );
          
        }

        return RefreshIndicator(
          onRefresh: () async {
            if (gallery.id != null) {
              controller.fetchGalleryDetails(gallery.id!);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        gallery.title ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: context.theme.textTheme.bodyLarge?.color,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        gallery.description ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.7),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (gallery.images != null && gallery.images!.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: gallery.images!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.78,
                            ),
                        itemBuilder: (context, index) {
                          final imageItem = gallery.images![index];

                          return GestureDetector(
                            // 👈 هنا نمرر القائمة الصريحة مع الاندكس
                            onTap: () => _openImagePreview(
                              context,
                              gallery.images!,
                              index,
                            ),
                            child: Container(
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
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        color: context.theme.primaryColor
                                            .withOpacity(0.04),
                                        child: Hero(
                                          tag:
                                              "gallery_image_${imageItem.imagePath ?? index.toString()}",
                                          child: Image.network(
                                            imageItem.imagePath ?? '',
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                    child: SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                              Color
                                                            >(
                                                              context
                                                                  .theme
                                                                  .primaryColor,
                                                            ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Center(
                                                    child: Icon(
                                                      Icons
                                                          .broken_image_rounded,
                                                      color: context
                                                          .theme
                                                          .disabledColor,
                                                      size: 28,
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (imageItem.caption != null &&
                                        imageItem.caption!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 8.0,
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            imageItem.caption!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: context
                                                  .theme
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color,
                                              height: 1.2,
                                            ),
                                            maxLines: 1,

                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    else
                      _buildEmptyState(
                        context: context,
                        icon: Icons.image_search_rounded,
                        message: "هذا الألبوم لا يحتوي على صور بعد",
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _openImagePreview(
    BuildContext context,
    List<dynamic> images,
    int initialIndex,
  ) {
    final PageController pageController = PageController(
      initialPage: initialIndex,
    );

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, _, __) {
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.95),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: PageView.builder(
              controller: pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                final item = images[index];
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 3.0,
                      child: Center(
                        child: Hero(
                          tag:
                              "gallery_image_${item.imagePath ?? index.toString()}",
                          child: Image.network(
                            item.imagePath ?? '',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    if (item.caption != null && item.caption!.isNotEmpty)
                      Positioned(
                        bottom: 40,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.caption!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 180,
              height: 24,
              decoration: BoxDecoration(
                color: context.theme.disabledColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 14,
              decoration: BoxDecoration(
                color: context.theme.disabledColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 250,
              height: 14,
              decoration: BoxDecoration(
                color: context.theme.disabledColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: context.theme.disabledColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required BuildContext context,
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 70,
              color: context.theme.disabledColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 15,
                color: context.theme.textTheme.bodyMedium?.color?.withOpacity(
                  0.5,
                ),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
