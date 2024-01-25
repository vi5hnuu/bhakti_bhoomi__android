import 'package:bhakti_bhoomi/models/aarti/AartiInfoModel.dart';
import 'package:bhakti_bhoomi/models/aarti/AartiModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:dio/dio.dart';

abstract class AartiService {
  Future<ApiResponse<List<AartiInfoModel>>> getAllAartiInfo({CancelToken? cancelToken});
  Future<ApiResponse<List<AartiModel>>> getAllAarti({CancelToken? cancelToken});
  Future<ApiResponse<AartiModel>> getAartiByTitle({required String title, CancelToken? cancelToken});
  Future<ApiResponse<AartiModel>> getAartiById({required String id, CancelToken? cancelToken});
}
