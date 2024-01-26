import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class BhagvadGeetaApi {
  static final BhagvadGeetaApi _instance = BhagvadGeetaApi._();

  static final String _bhagvadGeetaChaptersUrl = "${ApiConstants.baseUrl}/bhagavad_geeta/chapter"; //GET
  static final String _bhagvadGeetaShlokBychapterIdShlokIdUrl = "${ApiConstants.baseUrl}/bhagavad_geeta/chapterId/%chapterId%/shlokId/%shlokId%"; //GET
  static final String _bhagvadGeetaShlokBychapterIdShlokNoUrl = "${ApiConstants.baseUrl}/bhagavad_geeta/chapterId/%chapterId%/shlokNo/%shlokNo%"; //GET
  static final String _bhagvadGeetaShlokBychapterNoShlokNoUrl = "${ApiConstants.baseUrl}/bhagavad_geeta/chapterNo/%chapterNo%/shlokNo/%shlokNo%"; //GET
  static final String _bhagvadGeetaShloksByChapterIdUrl = "${ApiConstants.baseUrl}/bhagavad_geeta/chapter/%chapterId%/shlok"; //GET

  BhagvadGeetaApi._();
  factory BhagvadGeetaApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getbhagvadGeetaChapters({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_bhagvadGeetaChaptersUrl, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getbhagvadShlokByChapterIdShlokId({required String chapterId, required String shlokId, CancelToken? cancelToken}) async {
    var url = _bhagvadGeetaShlokBychapterIdShlokIdUrl.replaceAll("%chapterId%", '$chapterId').replaceAll("%shlokId%", '$shlokId');
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getbhagvadShlokByChapterIdShlokNo({required String chapterId, required int shlokNo, CancelToken? cancelToken}) async {
    var url = _bhagvadGeetaShlokBychapterIdShlokNoUrl.replaceAll("%chapterId%", '$chapterId').replaceAll("%shlokNo%", '$shlokNo');
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getbhagvadShlokByChapterNoShlokNo({required int chapterNo, required int shlokNo, CancelToken? cancelToken}) async {
    var url = _bhagvadGeetaShlokBychapterNoShlokNoUrl.replaceAll("%chapterNo%", '$chapterNo').replaceAll("%shlokNo%", '$shlokNo');
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getbhagvadGeetaShloks({required String chapterId, int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    var url = _bhagvadGeetaShloksByChapterIdUrl.replaceAll("%chapterId%", '$chapterId');
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
