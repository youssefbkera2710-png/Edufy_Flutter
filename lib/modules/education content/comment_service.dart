import 'package:edufy/models/content%20education/comments.dart';
import 'package:edufy/models/content%20education/edit_comment.dart';
import '../../core/config/app_endpoint.dart';
import '../../core/helpers/api_service.dart';
import '../../models/content education/add_comment.dart';
import '../../models/content education/delete_comment.dart';

class CommentsService {
  final ApiService apiService = ApiService();

  Future<CommentsModel?> getComments(int contentId, int page) async {
    try {
      final response = await apiService.get(
        url: AppEndpoints.getComments(contentId),
        //student/educational-contents/9
        query: {'per_page': 15, 'page': page},
      );

      if (response.statusCode == 200) {
        return CommentsModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Get Comments Error: $e");
      return null;
    }
  }

  Future<CommentsModel?> getReplies(int commentId) async {
    try {
      final response = await apiService.get(
        url: AppEndpoints.getReplies(commentId),
      );

      if (response.statusCode == 200) {
        return CommentsModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Get Comments Error: $e");
      return null;
    }
  }

  Future<AddCommentModel?> addComment({
    required int contentId,
    required String comment,
    int? parentId,
  }) async {
    try {
      final response = await apiService.post(
        url: AppEndpoints.addComment(contentId),
        data: {"comment": comment, "parent_comment_id": ?parentId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AddCommentModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Add Comment Error: $e");
      return null;
    }
  }

  Future<EditCommentModel?> editComment(
    int commentId,
    String newComment,
  ) async {
    try {
      final response = await apiService.post(
        url: AppEndpoints.editComment(commentId),
        data: {"comment": newComment},
      );

      if (response.statusCode == 200) {
        return EditCommentModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Edit Comment Error: $e");
      return null;
    }
  }

  Future<DeleteCommentModel?> deleteComment(int commentId) async {
    try {
      final response = await apiService.delete(
        url: AppEndpoints.deleteComment(commentId),
      );

      if (response.statusCode == 200) {
        return DeleteCommentModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Delete Comment Error: $e");
      return null;
    }
  }
}
