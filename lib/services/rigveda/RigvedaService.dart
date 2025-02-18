import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/models/rigveda/RigvedaInfoModel.dart';
import 'package:bhakti_bhoomi/models/rigveda/RigvedaSuktaModel.dart';
import 'package:dio/dio.dart';

abstract class RigvedaService {
  Future<ApiResponse<RigvedaInfoModel>> getRigvedaInfo({CancelToken? cancelToken});
  Future<ApiResponse<RigvedaSuktaModel>> getVerseByMandalaSukta({required int mandalaNo, required int suktaNo, CancelToken? cancelToken});
  Future<ApiResponse<RigvedaSuktaModel>> getVerseBySuktaId({required String suktaId, CancelToken? cancelToken});
  Future<ApiResponse<List<RigvedaSuktaModel>>> getVersesByMandala({required int mandalaNo, int? pageNo, int? pageSize, CancelToken? cancelToken});
}
