import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:edufy/models/media.dart';
import '../education_details_controller.dart';
import 'app_video_player.dart';

class MediaCarouselWidget extends StatelessWidget {
  final List<Media> mediaList;
  final Color accentColor;

  const MediaCarouselWidget({
    super.key,
    required this.mediaList,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EducationDetailsController>();

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: mediaList.length,
          itemBuilder: (context, index, _) =>
              _MediaItemFrame(media: mediaList[index]),
          options: CarouselOptions(
            height: 250,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            onPageChanged: (index, _) => controller.updateCarouselIndex(index),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              mediaList.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: controller.carouselIndex.value == index ? 12 : 7,
                height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: controller.carouselIndex.value == index
                      ? accentColor
                      : Colors.grey[300],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MediaItemFrame extends StatelessWidget {
  final Media media;
  const _MediaItemFrame({required this.media});

  void _openImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // تتيح للمستخدم التكبير والتصغير بالإصبعين
            InteractiveViewer(
              clipBehavior: Clip.none,
              minScale: 1.0,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image,
                  size: 60,
                  color: Colors.white54,
                ),
              ),
            ),
            // زر إغلاق المعاينة
            Positioned(
              top: 40,
              right: 20,
              child: SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = media.type?.toLowerCase() ?? '';
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[100],
        child: _buildChild(context, type),
      ),
    );
  }

  Widget _buildChild(BuildContext context, String type) {
    final controller = Get.find<EducationDetailsController>();

    if (type.contains('video')) {
      return AppVideoPlayer(url: media.url!);
    }

    if (type.contains('pdf')) {
      return InkWell(
        onTap: () => controller.openPdf(media.url!, media.name ?? 'Document'),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.picture_as_pdf_rounded,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  media.name ?? 'عرض ملف PDF',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "اضغط للمعاينة",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (media.url != null && media.url!.isNotEmpty) {
          _openImagePreview(context, media.url!);
        }
      },
      child: Image.network(
        media.url!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
        ),
      ),
    );
  }
}
