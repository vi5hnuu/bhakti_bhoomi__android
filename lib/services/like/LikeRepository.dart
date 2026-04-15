import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/models/like/LikeStatusModel.dart';
import 'package:bhakti_bhoomi/services/apis/LikeApi.dart';
import 'package:dio/dio.dart';

class LikeRepository {
  final LikeApi _api = LikeApi();

  Future<ApiResponse<LikeStatusModel>> toggleLike({
    required String contentId,
    CancelToken? cancelToken,
  }) async {
    final data = await _api.toggleLike(contentId: contentId, cancelToken: cancelToken);
    return ApiResponse(
      success: data['success'] as bool,
      data: LikeStatusModel(
        likedByMe: data['liked'] as bool,
        likeCount: data['likeCount'] as int,
      ),
    );
  }

  Future<ApiResponse<LikeStatusModel>> getLikeStatus({
    required String contentId,
    CancelToken? cancelToken,
  }) async {
    final data = await _api.getLikeStatus(contentId: contentId, cancelToken: cancelToken);
    return ApiResponse(
      success: data['success'] as bool,
      data: LikeStatusModel(
        likedByMe: data['likedByMe'] as bool,
        likeCount: data['likeCount'] as int,
      ),
    );
  }
}
