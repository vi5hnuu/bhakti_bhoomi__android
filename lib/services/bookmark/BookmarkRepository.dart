import 'package:bhakti_bhoomi/models/bookmark/BookmarkModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/BookmarkApi.dart';
import 'package:dio/dio.dart';

class BookmarkRepository {
  final BookmarkApi _api;
  static final BookmarkRepository _instance = BookmarkRepository._();
  BookmarkRepository._() : _api = BookmarkApi();
  factory BookmarkRepository() => _instance;

  Future<ApiResponse<List<BookmarkModel>>> getMyBookmarks({CancelToken? cancelToken}) async {
    final res = await _api.getMyBookmarks(cancelToken: cancelToken);
    final List<BookmarkModel> bookmarks = (res['data'] as List)
        .map((e) => BookmarkModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return ApiResponse(success: res['success'], data: bookmarks);
  }

  Future<ApiResponse<BookmarkModel>> addBookmark({
    required String contentId,
    required String contentType,
    CancelToken? cancelToken,
  }) async {
    final res = await _api.addBookmark(contentId: contentId, contentType: contentType, cancelToken: cancelToken);
    return ApiResponse(
      success: res['success'],
      message: res['message'],
      data: BookmarkModel.fromJson(res['data']),
    );
  }

  Future<ApiResponse> removeBookmark({required String bookmarkId, CancelToken? cancelToken}) async {
    final res = await _api.removeBookmark(bookmarkId: bookmarkId, cancelToken: cancelToken);
    return ApiResponse(success: res['success'], message: res['message']);
  }

  Future<ApiResponse<bool>> isBookmarked({required String contentId, CancelToken? cancelToken}) async {
    final res = await _api.isBookmarked(contentId: contentId, cancelToken: cancelToken);
    return ApiResponse(success: res['success'], data: res['data'] as bool);
  }
}
