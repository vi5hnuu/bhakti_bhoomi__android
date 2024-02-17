import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:bhakti_bhoomi/models/NewComment.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class CommentApi {
  static final CommentApi _instance = CommentApi._();

  static const String _likeUrl = "${ApiConstants.baseUrl}/comment/%id%/like"; //GET
  static const String _unlikeUrl = "${ApiConstants.baseUrl}/comment/%id%/un-like"; //GET
  static const String _getCommentUrl = "${ApiConstants.baseUrl}/comment/%id%"; //GET
  static const String _deleteCommentUrl = "${ApiConstants.baseUrl}/comment/%id%"; //GET
  static const String _createComment = "${ApiConstants.baseUrl}/comment/new"; //GET
  static const String _getCommentsByUserId = "${ApiConstants.baseUrl}/comment/user/%userId%"; //GET
  static const String _getComments = "${ApiConstants.baseUrl}/comment/comment-for/%commentForId%"; //GET

  CommentApi._();
  factory CommentApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> likeComment({required String id, CancelToken? cancelToken}) async {
    final likeUrl = _likeUrl.replaceAll("%id%", id);
    var res = await DioSingleton().dio.get(likeUrl, cancelToken: cancelToken);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> unlikeComment({required String id, CancelToken? cancelToken}) async {
    final unlikeUrl = _unlikeUrl.replaceAll("%id%", id);
    var res = await DioSingleton().dio.get(unlikeUrl, cancelToken: cancelToken);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getComment({required String id, CancelToken? cancelToken}) async {
    final getCommentUrl = _getCommentUrl.replaceAll("%id%", id);
    var res = await DioSingleton().dio.get(getCommentUrl, cancelToken: cancelToken);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createComment({required NewComment newComment, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.post(_createComment, data: newComment, cancelToken: cancelToken);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteComment({required String id, CancelToken? cancelToken}) async {
    final likeUrl = _deleteCommentUrl.replaceAll("%id%", id);
    var res = await DioSingleton().dio.delete(likeUrl, cancelToken: cancelToken);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getCommentsByUserId({required String userId, int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    String getCommentsUrl = _getCommentsByUserId.replaceAll("%userId%", userId);
    if (pageNo != null) {
      getCommentsUrl += "?pageNo=$pageNo";
    }
    if (pageSize != null) {
      getCommentsUrl += pageNo == null ? "?pageSize=$pageSize" : "&pageSize=$pageSize";
    }
    var res = await DioSingleton().dio.get(getCommentsUrl, cancelToken: cancelToken);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getComments({required String commentForId, String? parentCommentId, int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    String getCommentsUrl = _getComments.replaceAll("%commentForId%", commentForId);
    if (parentCommentId != null) {
      getCommentsUrl += "?parentCommentId=$parentCommentId";
    }
    if (pageNo != null) {
      getCommentsUrl += parentCommentId == null ? "?pageNo=$pageNo" : "&pageNo=$pageNo";
    }
    if (pageSize != null) {
      getCommentsUrl += pageNo != null || parentCommentId != null ? "&pageSize=$pageSize" : "?pageSize=$pageSize";
    }
    var res = await DioSingleton().dio.get(getCommentsUrl, cancelToken: cancelToken);
    return res.data as Map<String, dynamic>;
  }
}
