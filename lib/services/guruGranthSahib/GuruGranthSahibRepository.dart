import 'package:bhakti_bhoomi/models/guruGranthSahib/GuruGranthSahibInfoModel.dart';
import 'package:bhakti_bhoomi/models/guruGranthSahib/GuruGranthSahibRagaModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/GuruGranthSahibApi.dart';
import 'package:dio/dio.dart';
import 'GuruGranthSahibService.dart';

class GuruGranthSahibRepository implements GuruGranthSahibService {
  final GuruGranthSahibApi _guruGranthSahibApi;
  static final GuruGranthSahibRepository _instance = GuruGranthSahibRepository._();

  GuruGranthSahibRepository._() : _guruGranthSahibApi = GuruGranthSahibApi();
  factory GuruGranthSahibRepository() => _instance;

  @override
  Future<ApiResponse<GuruGranthSahibInfoModel>> getInfo({CancelToken? cancelToken}) async {
    final res = await _guruGranthSahibApi.getInfo(cancelToken: cancelToken);
    return ApiResponse<GuruGranthSahibInfoModel>(success: res['success'], data: GuruGranthSahibInfoModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<String>> getDescription({CancelToken? cancelToken}) async {
    final res = await _guruGranthSahibApi.getDescription(cancelToken: cancelToken);
    return ApiResponse<String>(success: res['success'], data: res['data']);
  }

  @override
  Future<ApiResponse<GuruGranthSahibRagaModel>> getRagaByRagaNamePartId({required String ragaName, required String partId, CancelToken? cancelToken}) async {
    final res = await _guruGranthSahibApi.getRagaByRagaNamePartId(ragaName: ragaName,partId: partId,cancelToken: cancelToken);
    return ApiResponse<GuruGranthSahibRagaModel>(success: res['success'], data: GuruGranthSahibRagaModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<GuruGranthSahibRagaModel>> getRagaByRagaNamePartNo({required String ragaName, required int partNo, CancelToken? cancelToken}) async {
    final res = await _guruGranthSahibApi.getRagaByRagaNamePartNo(ragaName: ragaName,partNo: partNo,cancelToken: cancelToken);
    return ApiResponse<GuruGranthSahibRagaModel>(success: res['success'], data: GuruGranthSahibRagaModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<GuruGranthSahibRagaModel>> getRagaByRagaNoPartId({required int ragaNo, required String partId, CancelToken? cancelToken}) async {
    final res = await _guruGranthSahibApi.getRagaByRagaNoPartId(ragaNo: ragaNo,partId: partId,cancelToken: cancelToken);
    return ApiResponse<GuruGranthSahibRagaModel>(success: res['success'], data: GuruGranthSahibRagaModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<GuruGranthSahibRagaModel>> getRagaByRagaNoPartNo({required int ragaNo, required int partNo, CancelToken? cancelToken}) async {
    final res = await _guruGranthSahibApi.getRagaByRagaNoPartNo(ragaNo: ragaNo,partNo: partNo,cancelToken: cancelToken);
    return ApiResponse<GuruGranthSahibRagaModel>(success: res['success'], data: GuruGranthSahibRagaModel.fromJson(res['data']));
  }
}
