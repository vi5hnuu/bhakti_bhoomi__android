import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class MantraApi {
  static final MantraApi _instance = MantraApi._();

  static const String _allMantraUrl = "${ApiConstants.baseUrl}/mantra/all"; //GET
  static const String _allMantraInfoUrl = "${ApiConstants.baseUrl}/mantra/all/info"; //GET
  static const String _allMantraAudioInfoUrl = "${ApiConstants.baseUrl}/mantra/all/audio/info"; //GET
  static const String _mantraByIdOrTitleUrl = "${ApiConstants.baseUrl}/mantra"; //GET
  static const String _mantraAudioByIdOrTitleUrl = "${ApiConstants.baseUrl}/mantra/audio"; //GET

  MantraApi._();
  factory MantraApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getAllMantraInfo({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_allMantraInfoUrl, cancelToken: cancelToken);
    return res.data;
  }
  Future<Map<String, dynamic>> getAllMantraAudioInfo({int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    var url = _allMantraAudioInfoUrl;
    if (pageNo != null) {
      url += '?pageNo=$pageNo';
    }
    if (pageSize != null) {
      url += pageNo != null ? '&pageSize=$pageSize' : '?pageSize=$pageSize';
    }
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getAllMantra({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_allMantraUrl, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getMantraById({required String id, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get('$_mantraByIdOrTitleUrl?id=$id', cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getMantraByTitle({required String title, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get('$_mantraByIdOrTitleUrl?title=$title', cancelToken: cancelToken);
    return res.data;
  }
  Future<Map<String, dynamic>> getMantraAudioById({required String id, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get('$_mantraAudioByIdOrTitleUrl?id=$id', cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getMantraAudioByTitle({required String title, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get('$_mantraAudioByIdOrTitleUrl?title=$title', cancelToken: cancelToken);
    return res.data;
  }
}
