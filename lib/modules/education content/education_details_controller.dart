import 'package:edufy/core/classes/subjects_helper.dart';
import 'package:edufy/core/shared/widgets/snackbar_def.dart';
import 'package:edufy/models/content%20education/education.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'education_content_controller.dart';
import 'education_content_service.dart';
import 'pdf_viewer_screen.dart';

class EducationDetailsController extends GetxController {
  final EducationalContentService service = EducationalContentService();
  final DraggableScrollableController sheetController =
      DraggableScrollableController();
  final ScrollController commentScrollController = ScrollController();

  final isDetailsLoading = false.obs;
  final selectedContentDetails = Rxn<Education>();
  final carouselIndex = 0.obs;

  late int contentID;
  int? childID;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments['child_id'] != null) {
      childID = Get.arguments['child_id'];
    } else if (Get.isRegistered<EducationalContentController>()) {
      childID = Get.find<EducationalContentController>().selectedChildId.value;
    }

    if (Get.arguments != null && Get.arguments['id'] != null) {
      contentID = Get.arguments['id'];
      getContentDetails(contentID);
    }
  }

  Future<void> getContentDetails(int id) async {
    isDetailsLoading.value = true;
    try {
      final result = await service.getContentDetails(id, childId: childID);
      if (result != null) {
        selectedContentDetails.value = result.data;
      }
    } catch (e) {
      snackBarDef('خطأ', 'فشل في تحميل البيانات', isError: true);
    } finally {
      isDetailsLoading.value = false;
    }
  }

  void toggleSheet() {
    double targetSize = sheetController.size > 0.12 ? 0.12 : 0.9;
    sheetController.animateTo(
      targetSize,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  void updateCarouselIndex(int index) => carouselIndex.value = index;

  void openPdf(String url, String title) {
    Get.to(() => PdfViewerScreen(url: url, title: title));
  }

  Color getSubjectColor(BuildContext context, String? subjectName) {
    return SubjectHelper.getSubjectColor(context, subjectName);
  }

  IconData getSubjectIcon(String? subjectName) {
    return SubjectHelper.getSubjectIcon(subjectName);
  }

  @override
  void onClose() {
    commentScrollController.dispose();
    sheetController.dispose();
    super.onClose();
  }
}
