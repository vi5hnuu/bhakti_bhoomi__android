import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:bhakti_bhoomi/singletons/DioSingleton.dart';
import 'package:dio/dio.dart';

class LikeApi {
  static final LikeApi _instance = LikeApi._();
  LikeApi._();
  factory LikeApi() => _instance;

  static const String _base = "${ApiConstants.baseUrl}/like";

  /// Returns {success, liked, likeCount}
  Future<Map<String, dynamic>> toggleLike({
    required String contentId,
    CancelToken? cancelToken,
  }) async {
    final res = await DioSingleton().dio.post('$_base/$contentId', cancelToken: cancelToken);
    return res.data;
  }

  /// Returns {success, likeCount, likedByMe}
  Future<Map<String, dynamic>> getLikeStatus({
    required String contentId,
    CancelToken? cancelToken,
  }) async {
    final res = await DioSingleton().dio.get('$_base/$contentId', cancelToken: cancelToken);
    return res.data;
  }
}
