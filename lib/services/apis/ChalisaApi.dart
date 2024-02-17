import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class ChalisaApi {
  static final ChalisaApi _instance = ChalisaApi._();

  static const String _allChalisaUrl = "${ApiConstants.baseUrl}/chalisa/all"; //GET
  static const String _allChalisaInfoUrl = "${ApiConstants.baseUrl}/chalisa/all/info"; //GET
  static const String _chalisaByIdOrTitleUrl = "${ApiConstants.baseUrl}/chalisa"; //GET

  ChalisaApi._();
  factory ChalisaApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getAllChalisaInfo({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_allChalisaInfoUrl, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getAllChalisa({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_allChalisaUrl, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getChalisaById({required String id, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get('$_chalisaByIdOrTitleUrl?id=$id', cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getChalisaByTitle({required String title, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get('$_chalisaByIdOrTitleUrl?title=$title', cancelToken: cancelToken);
    return res.data;
  }
}
