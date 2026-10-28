
import 'package:edufy/modules/my%20profile/top%20student/top_student_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edufy/models/top_student.dart';

class TopStudentsController extends GetxController {

  final RxList<TopStudent> students = <TopStudent>[].obs;
  final Rx<PaginationMeta?> pagination = Rx<PaginationMeta?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;

  final Rx<TopStudent?> selectedStudent = Rx<TopStudent?>(null);
  final RxBool isLoadingDetail = false.obs;
  final RxString detailError = ''.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchStudents();
    scrollController.addListener(onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMore();
    }
  }

  Future<void> fetchStudents({bool refresh = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    final result = await TopStudentService().getTopStudents(page: 1);

    if (result == null || result.status == 500) {
      errorMessage.value = result?.message ?? 'حدث خطأ غير متوقع';
    } else {
      students.assignAll(result.data);
      pagination.value = result.pagination;
    }

    isLoading.value = false;
  }

  Future<void> loadMore() async {
    final meta = pagination.value;
    if (meta == null || !meta.hasMorePages) return;
    if (isLoadingMore.value) return;

    isLoadingMore.value = true;

    final result = await TopStudentService().getTopStudents(page: meta.currentPage + 1);

    if (result != null && result.status != 500) {
      students.addAll(result.data);
      pagination.value = result.pagination;
    } else {
      Get.snackbar(
        'خطأ',
        result?.message ?? 'حدث خطأ غير متوقع',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }

    isLoadingMore.value = false;
  }

  Future<void> fetchStudentDetail(int id) async {
    isLoadingDetail.value = true;
    detailError.value = '';
    selectedStudent.value = null;

    final result = await TopStudentService().getTopStudentById(id: id);

    if (result == null || result.status == 500 || result.data == null) {
      detailError.value = result?.message ?? 'حدث خطأ غير متوقع';
    } else {
      selectedStudent.value = result.data;
    }

    isLoadingDetail.value = false;
  }
}