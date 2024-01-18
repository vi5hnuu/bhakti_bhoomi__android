import 'package:bhakti_bhoomi/models/mantra/MantraInfoModel.dart';
import 'package:bhakti_bhoomi/models/mantra/MantraModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';

abstract class MantraService {
  Future<ApiResponse<List<MantraInfoModel>>> getAllMantraInfo();
  Future<ApiResponse<List<MantraModel>>> getAllMantra();
  Future<ApiResponse<MantraModel>> getMantraById({required String id});
  Future<ApiResponse<MantraModel>> getMantraByTitle({required String title});
}
