import 'package:bhakti_bhoomi/models/aarti/AartiInfoModel.dart';
import 'package:bhakti_bhoomi/models/aarti/AartiModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/AartiApi.dart';

import 'AartiService.dart';

class AartiRepository implements AartiService {
  final AartiApi aartiApi;
  static final AartiRepository _instance = AartiRepository._();

  AartiRepository._() : aartiApi = AartiApi();
  factory AartiRepository() => _instance;

  @override
  Future<ApiResponse<AartiModel>> getAartiById({required String id}) async {
    final res = await aartiApi.getAartiById(id: id);
    return ApiResponse<AartiModel>(success: res['success'], data: AartiModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<AartiModel>> getAartiByTitle({required String title}) async {
    final res = await aartiApi.getAartiByTitle(title: title);
    return ApiResponse<AartiModel>(success: res['success'], data: AartiModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<AartiModel>>> getAllAarti() async {
    final res = await aartiApi.getAllAarti();
    return ApiResponse<List<AartiModel>>(success: res['success'], data: (res['data'] as List).map((e) => AartiModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<List<AartiInfoModel>>> getAllAartiInfo() async {
    final res = await aartiApi.getAllAartiInfo();
    return ApiResponse<List<AartiInfoModel>>(success: res['success'], data: (res['data'] as List).map((e) => AartiInfoModel.fromJson(e)).toList());
  }
}
