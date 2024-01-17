import 'package:bhakti_bhoomi/services/ApiConstants.dart';
import 'package:dio/dio.dart';

class BhagvadGeetaApi {
  static final BhagvadGeetaApi _instance = BhagvadGeetaApi._();

  static final String _bhagvadGeetaChaptersUrl = "${ApiConstants.baseUrl}/bhagavad_geeta//chapter"; //GET
  static final String _bhagvadGeetaChapterUrl = "${ApiConstants.baseUrl}/bhagavad_geeta/chapter/sacc"; //GET
  static final String _bhagvadGeetaShlokBychapterIdShlokIdUrl = "${ApiConstants.baseUrl}/bhagavad_geeta/chapter/%chapterId%/shlok/%shlokId%"; //GET
  static final String _bhagvadGeetaShloksByChapterIdUrl = "${ApiConstants.baseUrl}/bhagavad_geeta/chapter/%chapterId%/shlok"; //GET

  BhagvadGeetaApi._();
  factory BhagvadGeetaApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getbhagvadGeetaChapters() async {
    var res = await Dio().get(_bhagvadGeetaChaptersUrl);
    return res.data;
  }

  Future<Map<String, dynamic>> getbhagvadGeetaChapter({required String chapterId}) async {
    var res = await Dio().get('$_bhagvadGeetaChapterUrl/$chapterId');
    return res.data;
  }

  Future<Map<String, dynamic>> getbhagvadShlokByChapterIdShlokId({required String chapterId, required String shlokId}) async {
    var url = _bhagvadGeetaShlokBychapterIdShlokIdUrl.replaceAll("%chapterId%", '$chapterId').replaceAll("%shlokId%", '$shlokId');
    var res = await Dio().get(url);
    return res.data;
  }

  Future<Map<String, dynamic>> getbhagvadGeetaShloks({required String chapterId, int? pageNo, int? pageSize}) async {
    var url = _bhagvadGeetaShloksByChapterIdUrl.replaceAll("%chapterId%", '$chapterId');
    if (pageNo != null) {
      url += '?pageNo=$pageNo';
    }
    if (pageSize != null) {
      url = pageNo != null ? '&pageSize=$pageSize' : '?pageSize=$pageSize';
    }
    var res = await Dio().get(url);
    return res.data;
  }
}
