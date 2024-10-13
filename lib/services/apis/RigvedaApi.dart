import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class RigvedaApi {
  static final RigvedaApi _instance = RigvedaApi._();

  static const String _versesByMandalaUrl = "${ApiConstants.baseUrl}/rigveda/mandala/%mandalaNo%"; //GET
  static const String _rigvedaInfoUrl = "${ApiConstants.baseUrl}/rigveda/info"; //GET
  static const String _verseByMandalaSuktaUrl = "${ApiConstants.baseUrl}/rigveda/verse/mandala/%mandalaNo%/sukta/%suktaNo%"; //GET
  static const String _verseBySuktaIdUrl = "${ApiConstants.baseUrl}/rigveda/verse"; //GET

  RigvedaApi._();
  factory RigvedaApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getRigvedaInfo({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_rigvedaInfoUrl, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getVerseByMandalaSukta({required int mandalaNo, required int suktaNo, CancelToken? cancelToken}) async {
    var url = _verseByMandalaSuktaUrl.replaceAll("%mandalaNo%", '$mandalaNo').replaceAll("%suktaNo%", '$suktaNo');
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getVerseBySuktaId({required String suktaId, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get('$_rigvedaInfoUrl/$suktaId', cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getVersesByMandala({required int mandalaNo, int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    var url = _versesByMandalaUrl.replaceAll("%mandalaNo%", '$mandalaNo');
    if (pageNo != null) {
      url += '?pageNo=$pageNo';
    }
    if (pageSize != null) {
      url += pageNo != null ? '&pageSize=$pageSize' : '?pageSize=$pageSize';
    }

    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }
}
