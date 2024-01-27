import 'package:bhakti_bhoomi/models/mantra/MantraGroupModel.dart';
import 'package:bhakti_bhoomi/models/mantra/MantraInfoModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/MantraApi.dart';
import 'package:dio/dio.dart';

import 'MantraService.dart';

class MantraRepository implements MantraService {
  final MantraApi _mantraApi;
  static final MantraRepository _instance = MantraRepository._();

  MantraRepository._() : _mantraApi = MantraApi();
  factory MantraRepository() => _instance;

  @override
  Future<ApiResponse<List<MantraGroupModel>>> getAllMantra({CancelToken? cancelToken}) async {
    final res = await _mantraApi.getAllMantra(cancelToken: cancelToken);
    return ApiResponse<List<MantraGroupModel>>(success: res['success'], data: res['data'].map((e) => MantraGroupModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<List<MantraInfoModel>>> getAllMantraInfo({CancelToken? cancelToken}) async {
    final res = await _mantraApi.getAllMantraInfo(cancelToken: cancelToken);
    return ApiResponse<List<MantraInfoModel>>(success: res['success'], data: (res['data'] as List).map((e) => MantraInfoModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<MantraGroupModel>> getMantraById({required String id, CancelToken? cancelToken}) async {
    final res = await _mantraApi.getMantraById(id: id, cancelToken: cancelToken);
    return ApiResponse<MantraGroupModel>(success: res['success'], data: MantraGroupModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<MantraGroupModel>> getMantraByTitle({required String title, CancelToken? cancelToken}) async {
    final res = await _mantraApi.getMantraByTitle(title: title, cancelToken: cancelToken);
    return ApiResponse<MantraGroupModel>(success: res['successs'], data: MantraGroupModel.fromJson(res['data']));
  }
}
