import 'package:bhakti_bhoomi/models/CommentModel.dart';
import 'package:bhakti_bhoomi/models/NewComment.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/CommentsApi.dart';
import 'package:dio/dio.dart';

import 'CommentService.dart';

class CommentRepository implements CommentService {
  final CommentApi _commentApi;
  static final CommentRepository _instance = CommentRepository._();

  CommentRepository._() : _commentApi = CommentApi();
  factory CommentRepository() => _instance;

  @override
  Future<ApiResponse<CommentModel>> createComment({required NewComment newComment, CancelToken? cancelToken}) async {
    final res = await _commentApi.createComment(newComment: newComment, cancelToken: cancelToken);
    return ApiResponse<CommentModel>(success: res['success'], data: CommentModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse> deleteComment({required String id, CancelToken? cancelToken}) async {
    final res = await _commentApi.deleteComment(id: id, cancelToken: cancelToken);
    return ApiResponse<CommentModel>(success: res['success']);
  }

  @override
  Future<ApiResponse<CommentModel>> getComment({required String id, CancelToken? cancelToken}) async {
    final res = await _commentApi.getComment(id: id, cancelToken: cancelToken);
    return ApiResponse<CommentModel>(success: res['success'], data: CommentModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<CommentModel>>> getComments({required String commentForId, String? parentCommentId, int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    final res = await _commentApi.getComments(commentForId: commentForId, parentCommentId: parentCommentId, pageNo: pageNo, pageSize: pageSize, cancelToken: cancelToken);
    return ApiResponse<List<CommentModel>>(success: res['success'], data: (res['data'] as List).map((e) => CommentModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<List<CommentModel>>> getCommentsByUserId({required String userId, int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    final res = await _commentApi.getCommentsByUserId(userId: userId, pageNo: pageNo, pageSize: pageSize, cancelToken: cancelToken);
    return ApiResponse<List<CommentModel>>(success: res['success'], data: (res['data'] as List).map((e) => CommentModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse> likeComment({required String id, CancelToken? cancelToken}) async {
    final res = await _commentApi.likeComment(id: id, cancelToken: cancelToken);
    return ApiResponse<List<CommentModel>>(success: res['success']);
  }

  @override
  Future<ApiResponse> unlikeComment({required String id, CancelToken? cancelToken}) async {
    final res = await _commentApi.unlikeComment(id: id, cancelToken: cancelToken);
    return ApiResponse<List<CommentModel>>(success: res['success']);
  }
}
