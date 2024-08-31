import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class VratKathaApi {
  static final VratKathaApi _instance = VratKathaApi._();

  static const String _vratKathaInfoPage = "${ApiConstants.baseUrl}/vrat-katha/info"; //GET
  static const String _vratKathInfo = "${ApiConstants.baseUrl}/vrat-katha/info/{kathaId}"; //GET
  static const String _vratKathaById = "${ApiConstants.baseUrl}/vrat-katha/id/{kathaId}"; //GET
  static const String _vratKathaByTitle = "${ApiConstants.baseUrl}/vrat-katha/title/{kathaTitle}"; //GET


  VratKathaApi._();
  factory VratKathaApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getVratKathaInfoPage({required int pageNo,required int pageSize,CancelToken? cancelToken}) async {
    var url = '${_vratKathaInfoPage}?pageNo=$pageNo&pageSize=$pageSize';
    var res = await DioSingleton().dio.get(url);
    return res.data;
  }

  Future<Map<String, dynamic>> getVratKathInfo({required String kathaId, CancelToken? cancelToken}) async {
    var url = _vratKathInfo.replaceAll("{kathaId}", kathaId);;
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getVratKathaById({required String kathaId, CancelToken? cancelToken}) async {
    var url = _vratKathaById.replaceAll("{kathaId}", kathaId);
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getVratKathaByTitle({required String kathaTitle, CancelToken? cancelToken}) async {
    var url = _vratKathaByTitle.replaceAll("{kathaTitle}", kathaTitle);
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }
}
