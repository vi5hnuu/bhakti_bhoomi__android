import 'package:bhakti_bhoomi/models/CommentModel.dart';
import 'package:bhakti_bhoomi/models/NewComment.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:dio/dio.dart';

abstract class CommentService {
  Future<ApiResponse> likeComment({required String id, CancelToken? cancelToken});
  Future<ApiResponse> unlikeComment({required String id, CancelToken? cancelToken});
  Future<ApiResponse<CommentModel>> getComment({required String id, CancelToken? cancelToken});
  Future<ApiResponse<CommentModel>> createComment({required NewComment newComment, CancelToken? cancelToken});
  Future<ApiResponse> deleteComment({required String id, CancelToken? cancelToken});
  Future<ApiResponse<List<CommentModel>>> getCommentsByUserId({required String userId, int? pageNo, int? pageSize, CancelToken? cancelToken});
  Future<ApiResponse<List<CommentModel>>> getComments({required String commentForId, String? parentCommentId, int? pageNo, int? pageSize, CancelToken? cancelToken});
}
