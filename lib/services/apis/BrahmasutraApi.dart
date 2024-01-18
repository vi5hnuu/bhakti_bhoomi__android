import 'package:bhakti_bhoomi/services/ApiConstants.dart';
import 'package:dio/dio.dart';

class BrahmasutraApi {
  static final BrahmasutraApi _instance = BrahmasutraApi._();

  static final String _brahmasutraInfoUrl = "${ApiConstants.baseUrl}/brahmasutra/info"; //GET
  static final String _brahmasutraBySutraIdUrl = "${ApiConstants.baseUrl}/brahmasutra/sutra"; //GET
  static final String _brahmasutraByChapterNoQuaterNoSutraNoUrl = "${ApiConstants.baseUrl}/brahmasutra/chapter/%chapterNo%/quater/%quaterNo%/sutra/%sutraNo%"; //GET
  static final String _brahmasutrasByChapterNoQuaterNoUrl = "${ApiConstants.baseUrl}/brahmasutra/chapter/%chapterNo%/quater/%quaterNo%"; //GET

  BrahmasutraApi._();
  factory BrahmasutraApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getBrahmasutraInfo() async {
    var res = await Dio().get(_brahmasutraInfoUrl);
    return res.data;
  }

  Future<Map<String, dynamic>> getBrahmasutraBySutraId({required String sutraId, String? lang}) async {
    var url = '$_brahmasutraBySutraIdUrl/$sutraId';
    if (lang != null) {
      url += '?lang=$lang';
    }
    var res = await Dio().get(url);
    return res.data;
  }

  Future<Map<String, dynamic>> getbrahmasutraByChapterNoQuaterNoSutraNo({required int chapterNo, required int quaterNo, required int sutraNo, String? lang}) async {
    var url = _brahmasutraByChapterNoQuaterNoSutraNoUrl.replaceAll("%chapterNo%", '$chapterNo').replaceAll("%quaterNo%", '$quaterNo').replaceAll("%sutraNo%", '$sutraNo');
    if (lang != null) {
      url += '?lang=$lang';
    }
    var res = await Dio().get(url);
    return res.data;
  }

  Future<Map<String, dynamic>> getbrahmasutrasByChapterNoQuaterNo({required int chapterNo, required int quaterNo, int? pageNo, int? pageSize, String? lang}) async {
    var url = _brahmasutrasByChapterNoQuaterNoUrl.replaceAll("%chapterNo%", '$chapterNo').replaceAll("%quaterNo%", '$quaterNo');
    if (pageNo != null) {
      url += '?pageNo=$pageNo';
    }
    if (pageSize != null) {
      url = pageNo != null ? '&pageSize=$pageSize' : '?pageSize=$pageSize';
    }
    if (lang != null) {
      url = (pageNo != null || pageSize != null) ? '&lang=$lang' : '?lang=$lang';
    }
    var res = await Dio().get(url);
    return res.data;
  }
}
