import 'package:bhakti_bhoomi/models/ramayan/RamayanInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramayan/RamayanShlokModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/RamayanApi.dart';

import 'RamayanService.dart';

class RamayanRepository implements RamayanService {
  final RamayanApi ramayanApi;
  static final RamayanRepository _instance = RamayanRepository._();

  RamayanRepository._() : ramayanApi = RamayanApi();
  factory RamayanRepository() => _instance;

  @override
  Future<ApiResponse<RamayanInfoModel>> getRamayanInfo() async {
    final res = await ramayanApi.getRamayanInfo();
    return ApiResponse<RamayanInfoModel>(success: res['success'], data: RamayanInfoModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<RamayanShlokModel>> getRamayanShlokByKandSargaIdShlokNo({required String kanda, required String sargaId, required int shlokNo, String? lang}) async {
    final res = await ramayanApi.getRamayanShlokByKandSargaIdShlokNo(kanda: kanda, sargaId: sargaId, shlokNo: shlokNo, lang: lang);
    return ApiResponse<RamayanShlokModel>(success: res['success'], data: RamayanShlokModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<RamayanShlokModel>> getRamayanShlokByKandSargaNoShlokNo({required String kanda, required int sargaNo, required int shlokNo, String? lang}) async {
    final res = await ramayanApi.getRamayanShlokByKandSargaNoShlokNo(kanda: kanda, sargaNo: sargaNo, shlokNo: shlokNo, lang: lang);
    return ApiResponse<RamayanShlokModel>(success: res['success'], data: RamayanShlokModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<RamayanShlokModel>>> getRamayanShlokasByKandSargaId({required String kanda, required String sargaId, int? pageNo, int? pageSize, String? lang}) async {
    final res = await ramayanApi.getRamayanShlokasByKandSargaId(kanda: kanda, sargaId: sargaId, lang: lang);
    return ApiResponse<List<RamayanShlokModel>>(success: res['success'], data: res['data'].map((e) => RamayanShlokModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<List<RamayanShlokModel>>> getRamayanShlokasByKandSargaNo({required String kanda, required int sargaNo, int? pageNo, int? pageSize, String? lang}) async {
    final res = await ramayanApi.getRamayanInfo();
    return ApiResponse<List<RamayanShlokModel>>(success: res['success'], data: res['data'].map((e) => RamayanShlokModel.fromJson(e)).toList());
  }
}
