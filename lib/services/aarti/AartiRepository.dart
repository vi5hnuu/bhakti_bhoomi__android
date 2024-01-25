import 'package:bhakti_bhoomi/models/aarti/AartiInfoModel.dart';
import 'package:bhakti_bhoomi/models/aarti/AartiModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/AartiApi.dart';
import 'package:dio/dio.dart';

import 'AartiService.dart';

class AartiRepository implements AartiService {
  final AartiApi _aartiApi;
  static final AartiRepository _instance = AartiRepository._();

  AartiRepository._() : _aartiApi = AartiApi();
  factory AartiRepository() => _instance;

  @override
  Future<ApiResponse<AartiModel>> getAartiById({required String id, CancelToken? cancelToken}) async {
    final res = await _aartiApi.getAartiById(id: id);
    return ApiResponse<AartiModel>(success: res['success'], data: AartiModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<AartiModel>> getAartiByTitle({required String title, CancelToken? cancelToken}) async {
    final res = await _aartiApi.getAartiByTitle(title: title);
    return ApiResponse<AartiModel>(success: res['success'], data: AartiModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<AartiModel>>> getAllAarti({CancelToken? cancelToken}) async {
    final res = await _aartiApi.getAllAarti();
    return ApiResponse<List<AartiModel>>(success: res['success'], data: (res['data'] as List).map((e) => AartiModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<List<AartiInfoModel>>> getAllAartiInfo({CancelToken? cancelToken}) async {
    final res = await _aartiApi.getAllAartiInfo();
    return ApiResponse<List<AartiInfoModel>>(success: res['success'], data: (res['data'] as List).map((e) => AartiInfoModel.fromJson(e)).toList());
  }
}
