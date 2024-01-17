import 'package:bhakti_bhoomi/services/ApiConstants.dart';
import 'package:dio/dio.dart';

class RigvedaApi {
  static final RigvedaApi _instance = RigvedaApi._();

  static final String _versesByMandalaUrl = "${ApiConstants.baseUrl}/rigveda/mandala/%mandalaNo%"; //GET
  static final String _rigvedaInfoUrl = "${ApiConstants.baseUrl}/rigveda/info"; //GET
  static final String _verseByMandalaSuktaUrl = "${ApiConstants.baseUrl}/rigveda/verse/mandala/%mandalaNo%/sukta/%suktaNo%"; //GET
  static final String _verseBySuktaIdUrl = "${ApiConstants.baseUrl}/rigveda/verse"; //GET

  RigvedaApi._();
  factory RigvedaApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getRigvedaInfo() async {
    var res = await Dio().get(_rigvedaInfoUrl);
    return res.data;
  }

  Future<Map<String, dynamic>> getVerseByMandalaSukta({required int mandalaNo, required int suktaNo}) async {
    var url = _verseByMandalaSuktaUrl.replaceAll("%mandalaNo%", '$mandalaNo').replaceAll("%suktaNo%", '$suktaNo');
    var res = await Dio().get(url);
    return res.data;
  }

  Future<Map<String, dynamic>> getVerseBySuktaId({required String suktaId}) async {
    var res = await Dio().get('$_rigvedaInfoUrl/$suktaId');
    return res.data;
  }

  Future<Map<String, dynamic>> getVersesByMandala({required int mandalaNo, int? pageNo, int? pageSize}) async {
    var url = _versesByMandalaUrl.replaceAll("%mandalaNo%", '$mandalaNo');
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
