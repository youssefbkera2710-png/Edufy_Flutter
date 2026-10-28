import 'package:edufy/core/config/user_info.dart';
import 'package:edufy/core/shared/managers/themes_manager/themes_manager.dart';
import 'package:edufy/models/content%20education/comment.dart';
import 'package:edufy/modules/education%20content/comment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentsSectionWidget extends StatelessWidget {
  final int contentId;
  final bool allowComments;
  const CommentsSectionWidget({
    super.key,
    required this.contentId,
    required this.allowComments,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentsController());
    final colors = ColorManager.of(context).dynamicColors;
    final isDark = context.isDarkMode;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, controller, colors, isDark),
          const SizedBox(height: 16.0),
          if ((UserInfo.role == 'student' || UserInfo.role == 'guardian') &&
              allowComments)
            _buildInput(context, controller, colors),
          const SizedBox(height: 24.0),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: colors.primary),
              );
            }
            if (controller.commentsList.isEmpty) {
              return _buildEmptyState(colors, isDark);
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.commentsList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildCommentTile(
                      context,
                      controller.commentsList[index],
                      colors,
                    );
                  },
                ),
                if (controller.hasMore) ...[
                  const SizedBox(height: 16),
                  controller.isLoadingMore.value
                      ? Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: colors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: () => controller.getComments(contentId),
                          child: Text(
                            'تحميل المزيد من التعليقات',
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    CommentsController controller,
    dynamic colors,
    bool isDark,
  ) {
    return Row(
      children: [
        Text(
          'التعليقات',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? colors.white : colors.grey900,
          ),
        ),
        const SizedBox(width: 8),
        Obx(
          () => Text(
            '${controller.commentsList.length}',
            style: TextStyle(
              color: isDark ? colors.grey350 : colors.grey625,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInput(
    BuildContext context,
    CommentsController controller,
    dynamic colors,
  ) {
    final textController = TextEditingController();
    final isDark = context.isDarkMode;

    final String? userAvatarUrl = UserInfo.avatar?.toString();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: colors.primary.withOpacity(0.1),
          backgroundImage: (userAvatarUrl != null && userAvatarUrl.isNotEmpty)
              ? NetworkImage(userAvatarUrl)
              : null,
          child: (userAvatarUrl != null && userAvatarUrl.isNotEmpty)
              ? null
              : Icon(Icons.person, size: 20, color: colors.primary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: textController,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? colors.white : colors.grey900,
                      ),
                      decoration: InputDecoration(
                        hintText: 'اكتب تعليقاً...',
                        hintStyle: TextStyle(
                          color: isDark ? colors.grey350 : Colors.grey,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => controller.isSending.value
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.send_rounded,
                            color: colors.primary,
                            size: 20,
                          ),
                          onPressed: () async {
                            if (textController.text.trim().isNotEmpty) {
                              await controller.addCommentOrReply(
                                contentId: contentId,
                                text: textController.text,
                              );
                              textController.clear();
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentTile(
    BuildContext context,
    Comment comment,
    dynamic colors,
  ) {
    final controller = Get.find<CommentsController>();
    final isDark = context.isDarkMode;
    final RxBool isReplyInputVisible = false.obs;
    final RxBool isRepliesListVisible = false.obs;
    final replyController = TextEditingController();
    print(
      "اسم الطالب: ${comment.studentName} -> رابط الصورة: ${comment.userAvatar}",
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: colors.primary.withOpacity(0.1),
          backgroundImage:
              (comment.userAvatar != null && comment.userAvatar!.isNotEmpty)
              ? NetworkImage(comment.userAvatar!)
              : null,
          child: (comment.userAvatar != null && comment.userAvatar!.isNotEmpty)
              ? null
              : Icon(Icons.person, size: 18, color: colors.primary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onLongPressStart: comment.isOwn == true
                    ? (details) => _showLongPressMenu(
                        context,
                        details.globalPosition,
                        controller,
                        comment,
                      )
                    : (c) {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.studentName ?? 'مستخدم',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isDark ? colors.white : colors.grey900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        comment.comment ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? colors.grey150 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 4),
                child: Row(
                  children: [
                    Text(
                      _formatDate(comment.createdAt),
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    ),
                    const SizedBox(width: 16),
                    if (UserInfo.role == 'teacher')
                      GestureDetector(
                        onTap: () => isReplyInputVisible.toggle(),
                        child: Text(
                          'رد',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    if (comment.hasReplies == true) ...[
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          isRepliesListVisible.toggle();
                          if (isRepliesListVisible.value)
                            controller.getReplies(comment.id!);
                        },
                        child: Obx(
                          () => Text(
                            isRepliesListVisible.value
                                ? 'إخفاء الردود'
                                : 'عرض الردود',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Obx(
                () => isReplyInputVisible.value
                    ? _buildReplyInputField(
                        replyController,
                        controller,
                        comment,
                        isDark,
                        colors,
                        isReplyInputVisible,
                        isRepliesListVisible,
                      )
                    : const SizedBox.shrink(),
              ),
              Obx(
                () => isRepliesListVisible.value
                    ? _buildRepliesList(
                        controller,
                        comment.id!,
                        colors,
                        isDark,
                        context,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLongPressMenu(
    BuildContext context,
    Offset position,
    CommentsController controller,
    Comment comment,
  ) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              const Icon(Icons.edit, size: 18),
              const SizedBox(width: 8),
              const Text('تعديل'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete, size: 18, color: Colors.red),
              const SizedBox(width: 8),
              const Text('حذف', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ).then((value) {
      if (value == 'edit') _showEditDialog(context, controller, comment);
      if (value == 'delete') controller.removeComment(contentId, comment.id!);
    });
  }

  Widget _buildReplyInputField(
    TextEditingController ctrl,
    CommentsController controller,
    Comment comment,
    bool isDark,
    dynamic colors,
    RxBool visible,
    RxBool showList,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: ctrl,
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'اكتب رداً...',
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, size: 18, color: colors.primary),
            onPressed: () async {
              if (ctrl.text.trim().isNotEmpty) {
                await controller.addCommentOrReply(
                  contentId: contentId,
                  text: ctrl.text,
                  parentId: comment.id,
                );
                ctrl.clear();
                visible.value = false;
                showList.value = true;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRepliesList(
    CommentsController controller,
    int parentId,
    dynamic colors,
    bool isDark,
    BuildContext context,
  ) {
    if (controller.loadingReplies[parentId] == true) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    final replies = controller.repliesMap[parentId] ?? [];
    return Column(
      children: replies
          .map(
            (reply) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: colors.primary.withOpacity(0.1),
                    backgroundImage:
                        (reply.userAvatar != null &&
                            reply.userAvatar!.isNotEmpty)
                        ? NetworkImage(reply.userAvatar!)
                        : null,
                    child:
                        (reply.userAvatar != null &&
                            reply.userAvatar!.isNotEmpty)
                        ? null
                        : Icon(Icons.person, size: 14, color: colors.primary),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onLongPressStart: reply.isOwn == true
                              ? (details) => _showLongPressMenu(
                                  context,
                                  details.globalPosition,
                                  controller,
                                  reply,
                                )
                              : (details) {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withOpacity(0.06)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reply.studentName ?? 'مدرس',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: colors.primary,
                                  ),
                                ),
                                Text(
                                  reply.comment ?? '',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 2),
                          child: Text(
                            _formatDate(reply.createdAt),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  void _showEditDialog(
    BuildContext context,
    CommentsController controller,
    Comment comment,
  ) {
    final editController = TextEditingController(text: comment.comment);
    Get.defaultDialog(
      title: "تعديل التعليق",
      content: TextField(
        controller: editController,
        maxLines: 3,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.of(context).dynamicColors.primary,
        ),
        onPressed: () {
          controller.updateComment(contentId, comment.id!, editController.text);
          Get.back();
        },
        child: const Text("حفظ", style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("إلغاء"),
      ),
    );
  }

  Widget _buildEmptyState(dynamic colors, bool isDark) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.chat_bubble_outline, size: 40, color: Colors.grey[300]),
          const SizedBox(height: 8),
          const Text(
            'لا توجد تعليقات بعد',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes} د';
      if (diff.inHours < 24) return '${diff.inHours} س';
      return '${date.year}-${date.month}-${date.day}';
    } catch (e) {
      return dateStr.split('T').first;
    }
  }
}
