import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:bhakti_bhoomi/singletons/DioSingleton.dart';
import 'package:dio/dio.dart';

class PostApi {
  static final PostApi _instance = PostApi._();
  static const String _base = "${ApiConstants.baseUrl}/posts";

  PostApi._();
  factory PostApi() => _instance;

  Future<List<dynamic>> feed({int pageNo = 1, int pageSize = 10, CancelToken? cancelToken}) async {
    final res = await DioSingleton().dio.get(_base, queryParameters: {'pageNo': pageNo, 'pageSize': pageSize}, cancelToken: cancelToken);
    return List<dynamic>.from(res.data['data'] ?? []);
  }

  Future<Map<String, dynamic>> create({required String content, String? imageUrl, CancelToken? cancelToken}) async {
    final res = await DioSingleton().dio.post(_base, data: {'content': content, if (imageUrl != null) 'imageUrl': imageUrl}, cancelToken: cancelToken);
    return Map<String, dynamic>.from(res.data['data']);
  }

  Future<void> delete(String id, {CancelToken? cancelToken}) async {
    await DioSingleton().dio.delete('$_base/$id', cancelToken: cancelToken);
  }
}
