import 'package:bhakti_bhoomi/models/mantra/MantraInfoModel.dart';
import 'package:bhakti_bhoomi/models/mantra/MantraModel.dart';
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
  Future<ApiResponse<List<MantraModel>>> getAllMantra({CancelToken? cancelToken}) async {
    final res = await _mantraApi.getAllMantra(cancelToken: cancelToken);
    return ApiResponse<List<MantraModel>>(success: res['successs'], data: res['data'].map((e) => MantraModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<List<MantraInfoModel>>> getAllMantraInfo({CancelToken? cancelToken}) async {
    final res = await _mantraApi.getAllMantraInfo(cancelToken: cancelToken);
    return ApiResponse<List<MantraInfoModel>>(success: res['successs'], data: res['data'].map((e) => MantraInfoModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<MantraModel>> getMantraById({required String id, CancelToken? cancelToken}) async {
    final res = await _mantraApi.getMantraById(id: id, cancelToken: cancelToken);
    return ApiResponse<MantraModel>(success: res['successs'], data: MantraModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<MantraModel>> getMantraByTitle({required String title, CancelToken? cancelToken}) async {
    final res = await _mantraApi.getMantraByTitle(title: title, cancelToken: cancelToken);
    return ApiResponse<MantraModel>(success: res['successs'], data: MantraModel.fromJson(res['data']));
  }
}
