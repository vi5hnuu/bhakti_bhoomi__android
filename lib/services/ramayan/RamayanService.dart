import 'package:bhakti_bhoomi/models/ramayan/RamayanInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramayan/RamayanShlokModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:dio/dio.dart';

abstract class RamayanService {
  Future<ApiResponse<RamayanInfoModel>> getRamayanInfo({CancelToken? cancelToken});
  Future<ApiResponse<RamayanShlokModel>> getRamayanShlokByKandSargaNoShlokNo({required String kanda, required int sargaNo, required int shlokNo, String? lang, CancelToken? cancelToken});
  Future<ApiResponse<RamayanShlokModel>> getRamayanShlokByKandSargaIdShlokNo({required String kanda, required String sargaId, required int shlokNo, String? lang, CancelToken? cancelToken});
  Future<ApiResponse<List<RamayanShlokModel>>> getRamayanShlokasByKandSargaNo({required String kanda, required int sargaNo, int? pageNo, int? pageSize, String? lang, CancelToken? cancelToken});
  Future<ApiResponse<List<RamayanShlokModel>>> getRamayanShlokasByKandSargaId({required String kanda, required String sargaId, int? pageNo, int? pageSize, String? lang, CancelToken? cancelToken});
}
