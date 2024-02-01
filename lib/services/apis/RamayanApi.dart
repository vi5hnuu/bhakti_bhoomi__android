import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class RamayanApi {
  static final RamayanApi _instance = RamayanApi._();

  static final String _ramayanInfoUrl = "${ApiConstants.baseUrl}/ramayan/info"; //GET
  static final String _ramayanSargaInfoUrl = "${ApiConstants.baseUrl}/ramayan/kanda/%kanda%/sarga/%sargaNo%"; //GET
  static final String _ramayanSargasInfoUrl = "${ApiConstants.baseUrl}/ramayan/kanda/%kanda%/sargas"; //GET
  static final String _ramayanShlokByKandSargaNoShlokNoUrl = "${ApiConstants.baseUrl}/ramayan/kand/%kanda%/sargaNo/%sargaNo%/shlokNo/%shlokNo%"; //GET
  static final String _ramayanShlokByKandSargaIdShlokNoUrl = "${ApiConstants.baseUrl}/ramayan/kand/%kanda%/sargaId/%sargaId%/shlokNo/%shlokNo%"; //GET
  static final String _ramayanShlokasByKandSargaNo = "${ApiConstants.baseUrl}/ramayan/kand/%kand%/sargaNo/%sargaNo"; //GET
  static final String _ramayanShlokasByKandSargaId = "${ApiConstants.baseUrl}/ramayan/kand/%kand%/sargaId/%sargaId%"; //GET

  RamayanApi._();
  factory RamayanApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getRamayanInfo({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_ramayanInfoUrl, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getRamayanSargaInfo({required String kanda, required int sargaNo, CancelToken? cancelToken}) async {
    var url = _ramayanSargaInfoUrl.replaceAll("%kanda%", '$kanda').replaceAll("%sargaNo%", '$sargaNo');
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getRamayanSargasInfo({required String kanda, int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    var url = _ramayanSargasInfoUrl.replaceAll("%kanda%", '$kanda');
    if (pageNo != null) {
      url += '?pageNo=$pageNo';
    }
    if (pageSize != null) {
      url += pageNo != null ? '&pageSize=$pageSize' : '?pageSize=$pageSize';
    }
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getRamayanShlokByKandSargaNoShlokNo({required String kanda, required int sargaNo, required int shlokNo, String? lang, CancelToken? cancelToken}) async {
    var url = _ramayanShlokByKandSargaNoShlokNoUrl.replaceAll("%kanda%", '$kanda').replaceAll("%sargaNo%", '$sargaNo').replaceAll("%shlokNo%", '$shlokNo');
    if (lang != null) {
      url += '?lang=$lang';
    }
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getRamayanShlokByKandSargaIdShlokNo({required String kanda, required String sargaId, required int shlokNo, String? lang, CancelToken? cancelToken}) async {
    var url = _ramayanShlokByKandSargaIdShlokNoUrl.replaceAll("%kanda%", '$kanda').replaceAll("%sargaId%", '$sargaId').replaceAll("%shlokNo%", '$shlokNo');
    if (lang != null) {
      url += '?lang=$lang';
    }
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getRamayanShlokasByKandSargaNo({required String kanda, required int sargaNo, int? pageNo, int? pageSize, String? lang, CancelToken? cancelToken}) async {
    var url = _ramayanShlokasByKandSargaNo.replaceAll("%kanda%", '$kanda').replaceAll("%sargaNo%", '$sargaNo');
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

  Future<Map<String, dynamic>> getRamayanShlokasByKandSargaId({required String kanda, required String sargaId, int? pageNo, int? pageSize, String? lang, CancelToken? cancelToken}) async {
    var url = _ramayanShlokasByKandSargaId.replaceAll("%kanda%", '$kanda').replaceAll("%sargaId%", '$sargaId');
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
