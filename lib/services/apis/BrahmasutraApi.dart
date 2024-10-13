import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class BrahmasutraApi {
  static final BrahmasutraApi _instance = BrahmasutraApi._();

  static const String _brahmasutraInfoUrl = "${ApiConstants.baseUrl}/brahmasutra/info"; //GET
  static const String _brahmasutraBySutraIdUrl = "${ApiConstants.baseUrl}/brahmasutra/sutra"; //GET
  static const String _brahmasutraByChapterNoQuaterNoSutraNoUrl = "${ApiConstants.baseUrl}/brahmasutra/chapter/%chapterNo%/quater/%quaterNo%/sutra/%sutraNo%"; //GET
  static const String _brahmasutrasByChapterNoQuaterNoUrl = "${ApiConstants.baseUrl}/brahmasutra/chapter/%chapterNo%/quater/%quaterNo%"; //GET

  BrahmasutraApi._();
  factory BrahmasutraApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getBrahmasutraInfo({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_brahmasutraInfoUrl, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getBrahmasutraBySutraId({required String sutraId, String? lang, CancelToken? cancelToken}) async {
    var url = '$_brahmasutraBySutraIdUrl/$sutraId';
    if (lang != null) {
      url += '?lang=$lang';
    }
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getbrahmasutraByChapterNoQuaterNoSutraNo({required int chapterNo, required int quaterNo, required int sutraNo, String? lang, CancelToken? cancelToken}) async {
    var url = _brahmasutraByChapterNoQuaterNoSutraNoUrl.replaceAll("%chapterNo%", '$chapterNo').replaceAll("%quaterNo%", '$quaterNo').replaceAll("%sutraNo%", '$sutraNo');
    if (lang != null) {
      url += '?lang=$lang';
    }
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getbrahmasutrasByChapterNoQuaterNo({required int chapterNo, required int quaterNo, int? pageNo, int? pageSize, String? lang, CancelToken? cancelToken}) async {
    var url = _brahmasutrasByChapterNoQuaterNoUrl.replaceAll("%chapterNo%", '$chapterNo').replaceAll("%quaterNo%", '$quaterNo');
    if (pageNo != null) {
      url += '?pageNo=$pageNo';
    }
    if (pageSize != null) {
      url += pageNo != null ? '&pageSize=$pageSize' : '?pageSize=$pageSize';
    }
    if (lang != null) {
      url += (pageNo != null || pageSize != null) ? '&lang=$lang' : '?lang=$lang';
    }
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }
}
