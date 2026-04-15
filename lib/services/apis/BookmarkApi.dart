import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:bhakti_bhoomi/singletons/DioSingleton.dart';
import 'package:dio/dio.dart';

class BookmarkApi {
  static final BookmarkApi _instance = BookmarkApi._();
  BookmarkApi._();
  factory BookmarkApi() => _instance;

  static const String _base = "${ApiConstants.baseUrl}/bookmarks";

  Future<Map<String, dynamic>> getMyBookmarks({CancelToken? cancelToken}) async {
    final res = await DioSingleton().dio.get('$_base/me', cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> addBookmark({
    required String contentId,
    required String contentType,
    CancelToken? cancelToken,
  }) async {
    final res = await DioSingleton().dio.post(
      _base,
      data: {'contentId': contentId, 'contentType': contentType},
      cancelToken: cancelToken,
    );
    return res.data;
  }

  Future<Map<String, dynamic>> removeBookmark({
    required String bookmarkId,
    CancelToken? cancelToken,
  }) async {
    final res = await DioSingleton().dio.delete('$_base/$bookmarkId', cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> isBookmarked({
    required String contentId,
    CancelToken? cancelToken,
  }) async {
    final res = await DioSingleton().dio.get('$_base/check/$contentId', cancelToken: cancelToken);
    return res.data;
  }
}
