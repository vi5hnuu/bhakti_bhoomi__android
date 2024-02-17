import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class RamcharitmanasApi {
  static final RamcharitmanasApi _instance = RamcharitmanasApi._();

  static const String _ramcharitmanasInfoUrl = "${ApiConstants.baseUrl}/ramcharitmanas/info"; //GET
  static const String _ramcharitmanasVerseByVerseIdUrl = "${ApiConstants.baseUrl}/ramcharitmanas/verse"; //GET
  static const String _ramcharitmanasVerseByKandaAndVerseNoUrl = "${ApiConstants.baseUrl}/ramcharitmanas/kanda/%kanda%/verse/%verseNo%"; //GET
  static const String _ramcharitmanasMangalaCharanByKandaUrl = "${ApiConstants.baseUrl}/ramcharitmanas/mangalacharan/kanda/%kanda%"; //GET
  static const String _ramcharitmanasAllMangalacharanUrl = "${ApiConstants.baseUrl}/ramcharitmanas/mangalacharan/all"; //GET
  static const String _ramcharitmanasVersesByKandaUrl = "${ApiConstants.baseUrl}/ramcharitmanas/verses/kanda"; //GET

  RamcharitmanasApi._();
  factory RamcharitmanasApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getRamcharitmanasInfo({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_ramcharitmanasInfoUrl);
    return res.data;
  }

  Future<Map<String, dynamic>> getRamcharitmanasVerseById({required String id, String? lang, CancelToken? cancelToken}) async {
    var url = '$_ramcharitmanasVerseByVerseIdUrl/$id';
    if (lang != null) {
      url += '?lang=$lang';
    }

    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getRamcharitmanasVerseByKandaAndVerseNo({required String kanda, required int verseNo, String? lang, CancelToken? cancelToken}) async {
    var url = _ramcharitmanasVerseByKandaAndVerseNoUrl.replaceAll("%kanda%", '$kanda').replaceAll("%verseNo%", '$verseNo');
    if (lang != null) {
      url += '?lang=$lang';
    }
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getRamcharitmanasMangalacharanByKanda({required String kanda, String? lang, CancelToken? cancelToken}) async {
    var url = _ramcharitmanasMangalaCharanByKandaUrl.replaceAll("%kanda%", '$kanda');
    if (lang != null) {
      url += '?lang=$lang';
    }
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getRamcharitmanasAllMangalacharan({String? lang, CancelToken? cancelToken}) async {
    var url = _ramcharitmanasAllMangalacharanUrl;
    if (lang != null) {
      url += '?lang=$lang';
    }
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getRamcharitmanasVersesByKand({required String kanda, String? lang, int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    var url = '$_ramcharitmanasVersesByKandaUrl/$kanda';

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
