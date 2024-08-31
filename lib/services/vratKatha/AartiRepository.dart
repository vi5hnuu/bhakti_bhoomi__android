import 'package:bhakti_bhoomi/models/aarti/AartiInfoModel.dart';
import 'package:bhakti_bhoomi/models/aarti/AartiModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/models/vratKatha/VratkathaInfoModel.dart';
import 'package:bhakti_bhoomi/models/vratKatha/VratkathaInfoPageModel.dart';
import 'package:bhakti_bhoomi/models/vratKatha/VratkathaModel.dart';
import 'package:bhakti_bhoomi/services/apis/AartiApi.dart';
import 'package:bhakti_bhoomi/services/apis/VratkathaApi.dart';
import 'package:dio/dio.dart';

import 'AartiService.dart';

class VratKathaRepository implements AartiService {
  final VratKathaApi _vratKathaApi;
  static final VratKathaRepository _instance = VratKathaRepository._();

  VratKathaRepository._() : _vratKathaApi = VratKathaApi();
  factory VratKathaRepository() => _instance;

  @override
  Future<ApiResponse<VratkathaInfoModel>> getVratKathInfo({required String kathaId, CancelToken? cancelToken}) async {
    final res = await _vratKathaApi.getVratKathInfo(kathaId: kathaId, cancelToken: cancelToken);
    return ApiResponse<VratkathaInfoModel>(success: res['success'], data: VratkathaInfoModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<VratkathaModel>> getVratKathaById({required String kathaId, CancelToken? cancelToken}) async {
    final res = await _vratKathaApi.getVratKathaById(kathaId: kathaId, cancelToken: cancelToken);
    return ApiResponse<VratkathaModel>(success: res['success'], data: VratkathaModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<VratkathaModel>> getVratKathaByTitle({required String kathaTitle, CancelToken? cancelToken}) async {
    final res = await _vratKathaApi.getVratKathaByTitle(kathaTitle: kathaTitle, cancelToken: cancelToken);
    return ApiResponse<VratkathaModel>(success: res['success'], data: VratkathaModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<VratkathaInfoPageModel>> getVratKathaInfoPage({required pageNo, required pageSize, CancelToken? cancelToken}) async {
    final res = await _vratKathaApi.getVratKathaInfoPage(pageNo: pageNo,pageSize:pageSize, cancelToken: cancelToken);
    return ApiResponse<VratkathaInfoPageModel>(success: res['success'], data: VratkathaInfoPageModel.fromJson(res['data']));
  }
}
