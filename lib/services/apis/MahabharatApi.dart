import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class MahabharatApi {
  static final MahabharatApi _instance = MahabharatApi._();

  static const String _mahabharatInfoUrl = "${ApiConstants.baseUrl}/mahabharat/info"; //GET
  static const String _mahabharatShlokByIdUrl = "${ApiConstants.baseUrl}/mahabharat/shlok"; //GET
  static const String _mahabharatShloksByBookChapterUrl = "${ApiConstants.baseUrl}/mahabharat/book/%bookNo%/chapter/%chapterNo%"; //GET
  static const String _mahabharatShlokByShlokNoUrl = "${ApiConstants.baseUrl}/mahabharat/book/%bookNo%/chapter/%chapterNo%/shlok/%shlokNo%"; //GET

  MahabharatApi._();
  factory MahabharatApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getMahabharatInfo({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_mahabharatInfoUrl, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getMahabharatShlokById({required String id, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get('$_mahabharatShlokByIdUrl?id=$id', cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getMahabharatShlokByShlokNo({required int bookNo, required int chapterNo, required int shlokNo, CancelToken? cancelToken}) async {
    var url = _mahabharatShlokByShlokNoUrl.replaceAll("%bookNo%", '$bookNo').replaceAll("%chapterNo%", '$chapterNo').replaceAll("%shlokNo%", '$shlokNo');
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getMahabharatShloksByBookChapter({required int bookNo, required int chapterNo, int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    var url = _mahabharatShloksByBookChapterUrl.replaceAll("%bookNo%", '$bookNo').replaceAll("%chapterNo%", '$chapterNo');
    if (pageNo != null) {
      url += '?pageNo=$pageNo';
    }
    if (pageSize != null) {
      url = pageNo != null ? '&pageSize=$pageSize' : '?pageSize=$pageSize';
    }
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }
}
