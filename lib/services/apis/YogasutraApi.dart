import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class YogasutraApi {
  static final YogasutraApi _instance = YogasutraApi._();

  static final String _yogasutraInfoUrl = "${ApiConstants.baseUrl}/yogasutra/info"; //GET
  static final String _yogasutraBySutraIdUrl = "${ApiConstants.baseUrl}/yogasutra/sutra"; //GET
  static final String _yogasutraByChapterNoSutraNoUrl = "${ApiConstants.baseUrl}/yogasutra/chapter/%chapterNo%/sutra/%sutraNo%"; //GET
  static final String _yogasutrasByChapterNo = "${ApiConstants.baseUrl}/yogasutra/all/chapter"; //GET

  YogasutraApi._();
  factory YogasutraApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getyogasutraInfo({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_yogasutraInfoUrl, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getYogasutraBySutraId({required String sutraId, String? lang, CancelToken? cancelToken}) async {
    var url = '$_yogasutraBySutraIdUrl?id=$sutraId';
    if (lang != null) {
      url += '?lang=$lang';
    }
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getYogasutraByChapterNoSutraNo({required int chapterNo, required int sutraNo, String? lang, CancelToken? cancelToken}) async {
    var url = _yogasutraByChapterNoSutraNoUrl.replaceAll("%chapterNo%", '$chapterNo').replaceAll("%sutraNo%", '$sutraNo');
    if (lang != null) {
      url += '?lang=$lang';
    }
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getYogasutrasByChapterNo({required int chapterNo, int? pageNo, int? pageSize, String? lang, CancelToken? cancelToken}) async {
    var url = '$_yogasutrasByChapterNo/$chapterNo';

    if (pageNo != null) {
      url += '?pageNo=$pageNo';
    }
    if (pageSize != null) {
      url = pageNo != null ? '&pageSize=$pageSize' : '?pageSize=$pageSize';
    }
    if (lang != null) {
      url = (pageNo != null || pageSize != null) ? '&lang=$lang' : '?lang=$lang';
    }
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }
}
