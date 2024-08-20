import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class GuruGranthSahibApi {
  static final GuruGranthSahibApi _instance = GuruGranthSahibApi._();

  static const String _info = "${ApiConstants.baseUrl}/guru-granth-sahib/info"; //GET
  static const String _ragaByRagaNoPartNo = "${ApiConstants.baseUrl}/guru-granth-sahib/raga-no/{ragaNo}/part-no/{partNo}"; //GET
  static const String _ragaByRagaNoPartId = "${ApiConstants.baseUrl}/guru-granth-sahib/raga-no/{ragaNo}/part-id/{partId}"; //GET
  static const String _ragaByRagaNamePartNo = "${ApiConstants.baseUrl}/guru-granth-sahib/raga-name/{ragaName}/part-no/{partNo}"; //GET
  static const String _ragaByRagaNamePartId = "${ApiConstants.baseUrl}/guru-granth-sahib/raga-name/{ragaName}/part-id/{partId}"; //GET
  static const String _description = "${ApiConstants.baseUrl}/guru-granth-sahib/Description"; //GET

  GuruGranthSahibApi._();
  factory GuruGranthSahibApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getInfo({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_info, cancelToken: cancelToken);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getRagaByRagaNoPartNo({required int ragaNo,required int partNo,CancelToken? cancelToken}) async {
    var url = _ragaByRagaNoPartNo.replaceAll("{ragaNo}", '$ragaNo').replaceAll("{partNo}", '$partNo');
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getRagaByRagaNoPartId({required int ragaNo,required String partId,CancelToken? cancelToken}) async {
    var url = _ragaByRagaNoPartId.replaceAll("{ragaNo}", '$ragaNo').replaceAll("{partId}", partId);
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getRagaByRagaNamePartNo({required String ragaName,required int partNo,CancelToken? cancelToken}) async {
    var url = _ragaByRagaNamePartNo.replaceAll("{ragaName}", ragaName).replaceAll("{partNo}", '$partNo');
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getRagaByRagaNamePartId({required String ragaName,required String partId,CancelToken? cancelToken}) async {
    var url = _ragaByRagaNamePartId.replaceAll("{ragaName}", ragaName).replaceAll("{partId}", partId);
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getDescription({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_description, cancelToken: cancelToken);
    return res.data;
  }
}
