import 'package:edufy/core/shared/widgets/snackbar_def.dart';
import 'package:get/get.dart';
import '../../models/content%20education/comment.dart';
import 'comment_service.dart';

class CommentsController extends GetxController {
  final CommentsService _service = CommentsService();

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isSending = false.obs;
  final commentsList = <Comment>[].obs;

  final repliesMap = <int, List<Comment>>{}.obs;
  final loadingReplies = <int, bool>{}.obs;

  late int contentId;

  int _currentPage = 1;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  @override
  void onInit() {
    contentId = Get.arguments['id'] as int;
    getComments(contentId, isRefresh: true);
    super.onInit();
  }

  Future<void> getComments(int contentId, {bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasMore = true;
      isLoading.value = true;
    } else {
      if (!_hasMore || isLoadingMore.value) return;
      isLoadingMore.value = true;
    }

    try {
      final result = await _service.getComments(contentId, _currentPage);

      if (result != null && result.status == 200) {
        final List<Comment> fetchedComments = result.data ?? [];

        if (isRefresh) {
          commentsList.assignAll(fetchedComments);
        } else {
          commentsList.addAll(fetchedComments);
        }

        if (fetchedComments.length < 10) {
          _hasMore = false;
        } else {
          _currentPage++;
        }
      }
    } catch (e) {
      snackBarDef('خطأ', 'فشل في تحميل التعليقات', isError: true);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> getReplies(int commentId) async {
    if (repliesMap.containsKey(commentId)) return;

    loadingReplies[commentId] = true;
    try {
      final result = await _service.getReplies(commentId);
      if (result != null && result.status == 200) {
        repliesMap[commentId] = result.data ?? [];
      }
    } catch (e) {
      snackBarDef('خطأ', 'فشل في تحميل الردود', isError: true);
    } finally {
      loadingReplies[commentId] = false;
      loadingReplies.refresh();
    }
  }

  Future<void> addCommentOrReply({
    required int contentId,
    required String text,
    int? parentId,
  }) async {
    if (text.trim().isEmpty) return;
    isSending.value = true;
    try {
      final result = await _service.addComment(
        contentId: contentId,
        comment: text,
        parentId: parentId,
      );
      if (result != null && (result.status == 201 || result.status == 200)) {
        snackBarDef('نجاح', result.message ?? 'تمت الإضافة بنجاح');
        if (parentId != null) {
          repliesMap.remove(parentId);
          getReplies(parentId);
        } else {
          getComments(contentId, isRefresh: true);
        }
      }
    } catch (e) {
      snackBarDef('خطأ', 'فشل في إرسال التعليق', isError: true);
    } finally {
      isSending.value = false;
    }
  }

  Future<void> updateComment(
    int contentId,
    int commentId,
    String newText,
  ) async {
    if (newText.trim().isEmpty) return;
    isLoading.value = true;
    try {
      final result = await _service.editComment(commentId, newText);
      if (result != null) {
        snackBarDef('نجاح', 'تم تحديث التعليق');
        getComments(contentId, isRefresh: true);
      }
    } catch (e) {
      snackBarDef('خطأ', 'فشل في تعديل التعليق', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeComment(int contentId, int commentId) async {
    try {
      final result = await _service.deleteComment(commentId);
      if (result != null) {
        snackBarDef('نجاح', 'تم حذف التعليق');
        getComments(contentId, isRefresh: true);
      }
    } catch (e) {
      snackBarDef('خطأ', 'لا يمكن الحذف حالياً', isError: true);
    }
  }
}
