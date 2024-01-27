import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/models/rigveda/RigvedaInfoModel.dart';
import 'package:bhakti_bhoomi/models/rigveda/RigvedaSuktaModel.dart';
import 'package:bhakti_bhoomi/services/apis/RigvedaApi.dart';
import 'package:bhakti_bhoomi/services/rigveda/RigvedaService.dart';
import 'package:dio/dio.dart';

class RigvedaRepository implements RigvedaService {
  final RigvedaApi _rigvedaApi;
  static final RigvedaRepository _instance = RigvedaRepository._();

  RigvedaRepository._() : _rigvedaApi = RigvedaApi();
  factory RigvedaRepository() => _instance;

  @override
  Future<ApiResponse<RigvedaInfoModel>> getRigvedaInfo({CancelToken? cancelToken}) async {
    final res = await _rigvedaApi.getRigvedaInfo(cancelToken: cancelToken);
    return ApiResponse<RigvedaInfoModel>(success: res['success'], data: RigvedaInfoModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<RigvedaSuktaModel>> getVerseByMandalaSukta({required int mandalaNo, required int suktaNo, CancelToken? cancelToken}) async {
    final res = await _rigvedaApi.getVerseByMandalaSukta(mandalaNo: mandalaNo, suktaNo: suktaNo, cancelToken: cancelToken);
    return ApiResponse<RigvedaSuktaModel>(success: res['success'], data: RigvedaSuktaModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<RigvedaSuktaModel>> getVerseBySuktaId({required String suktaId, CancelToken? cancelToken}) async {
    final res = await _rigvedaApi.getVerseBySuktaId(suktaId: suktaId, cancelToken: cancelToken);
    return ApiResponse<RigvedaSuktaModel>(success: res['success'], data: RigvedaSuktaModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<RigvedaSuktaModel>>> getVersesByMandala({required int mandalaNo, int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    final res = await _rigvedaApi.getVersesByMandala(mandalaNo: mandalaNo, pageNo: pageNo, pageSize: pageSize, cancelToken: cancelToken);
    return ApiResponse<List<RigvedaSuktaModel>>(success: res['data'], data: res['data'].map((e) => RigvedaSuktaModel.fromJson(e)).toList());
  }
}
