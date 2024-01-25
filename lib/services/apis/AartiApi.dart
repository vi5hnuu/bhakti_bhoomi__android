import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class AartiApi {
  static final AartiApi _instance = AartiApi._();

  static final String _allAartiUrl = "${ApiConstants.baseUrl}/aarti/all"; //GET
  static final String _allAartiInfoUrl = "${ApiConstants.baseUrl}/aarti/all/info"; //GET
  static final String _aartiByIdOrTitleUrl = "${ApiConstants.baseUrl}/aarti"; //GET

  AartiApi._();
  factory AartiApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getAllAartiInfo({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_allAartiInfoUrl, cancelToken: cancelToken);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAllAarti({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_allAartiUrl, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getAartiById({required String id, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get('$_aartiByIdOrTitleUrl?id=$id', cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getAartiByTitle({required String title, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get('$_aartiByIdOrTitleUrl?title=$title', cancelToken: cancelToken);
    return res.data;
  }
}
