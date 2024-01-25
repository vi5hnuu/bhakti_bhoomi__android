import 'package:bhakti_bhoomi/models/ramayan/RamayanInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramayan/RamayanShlokModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/RamayanApi.dart';
import 'package:dio/dio.dart';

import 'RamayanService.dart';

class RamayanRepository implements RamayanService {
  final RamayanApi _ramayanApi;
  static final RamayanRepository _instance = RamayanRepository._();

  RamayanRepository._() : _ramayanApi = RamayanApi();
  factory RamayanRepository() => _instance;

  @override
  Future<ApiResponse<RamayanInfoModel>> getRamayanInfo({CancelToken? cancelToken}) async {
    final res = await _ramayanApi.getRamayanInfo(cancelToken: cancelToken);
    return ApiResponse<RamayanInfoModel>(success: res['success'], data: RamayanInfoModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<RamayanShlokModel>> getRamayanShlokByKandSargaIdShlokNo({required String kanda, required String sargaId, required int shlokNo, String? lang, CancelToken? cancelToken}) async {
    final res = await _ramayanApi.getRamayanShlokByKandSargaIdShlokNo(kanda: kanda, sargaId: sargaId, shlokNo: shlokNo, lang: lang, cancelToken: cancelToken);
    return ApiResponse<RamayanShlokModel>(success: res['success'], data: RamayanShlokModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<RamayanShlokModel>> getRamayanShlokByKandSargaNoShlokNo({required String kanda, required int sargaNo, required int shlokNo, String? lang, CancelToken? cancelToken}) async {
    final res = await _ramayanApi.getRamayanShlokByKandSargaNoShlokNo(kanda: kanda, sargaNo: sargaNo, shlokNo: shlokNo, lang: lang, cancelToken: cancelToken);
    return ApiResponse<RamayanShlokModel>(success: res['success'], data: RamayanShlokModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<RamayanShlokModel>>> getRamayanShlokasByKandSargaId(
      {required String kanda, required String sargaId, int? pageNo, int? pageSize, String? lang, CancelToken? cancelToken}) async {
    final res = await _ramayanApi.getRamayanShlokasByKandSargaId(kanda: kanda, sargaId: sargaId, lang: lang, cancelToken: cancelToken);
    return ApiResponse<List<RamayanShlokModel>>(success: res['success'], data: res['data'].map((e) => RamayanShlokModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<List<RamayanShlokModel>>> getRamayanShlokasByKandSargaNo({required String kanda, required int sargaNo, int? pageNo, int? pageSize, String? lang, CancelToken? cancelToken}) async {
    final res = await _ramayanApi.getRamayanInfo(cancelToken: cancelToken);
    return ApiResponse<List<RamayanShlokModel>>(success: res['success'], data: res['data'].map((e) => RamayanShlokModel.fromJson(e)).toList());
  }
}
