import 'package:bhakti_bhoomi/models/aarti/AartiInfoModel.dart';
import 'package:bhakti_bhoomi/models/aarti/AartiModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';

abstract class AartiService {
  Future<ApiResponse<List<AartiInfoModel>>> getAllAartiInfo();
  Future<ApiResponse<List<AartiModel>>> getAllAarti();
  Future<ApiResponse<AartiModel>> getAartiByTitle({required String title});
  Future<ApiResponse<AartiModel>> getAartiById({required String id});
}
