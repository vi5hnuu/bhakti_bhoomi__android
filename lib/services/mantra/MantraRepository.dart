import 'package:bhakti_bhoomi/models/mantra/MantraInfoModel.dart';
import 'package:bhakti_bhoomi/models/mantra/MantraModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/MantraApi.dart';

import 'MantraService.dart';

class MantraRepository implements MantraService {
  final MantraApi mantraApi;
  static final MantraRepository _instance = MantraRepository._();

  MantraRepository._() : mantraApi = MantraApi();
  factory MantraRepository() => _instance;

  @override
  Future<ApiResponse<List<MantraModel>>> getAllMantra() async {
    final res = await mantraApi.getAllMantra();
    return ApiResponse<List<MantraModel>>(success: res['successs'], data: res['data'].map((e) => MantraModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<List<MantraInfoModel>>> getAllMantraInfo() async {
    final res = await mantraApi.getAllMantraInfo();
    return ApiResponse<List<MantraInfoModel>>(success: res['successs'], data: res['data'].map((e) => MantraInfoModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<MantraModel>> getMantraById({required String id}) async {
    final res = await mantraApi.getMantraById(id: id);
    return ApiResponse<MantraModel>(success: res['successs'], data: MantraModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<MantraModel>> getMantraByTitle({required String title}) async {
    final res = await mantraApi.getMantraByTitle(title: title);
    return ApiResponse<MantraModel>(success: res['successs'], data: MantraModel.fromJson(res['data']));
  }
}
