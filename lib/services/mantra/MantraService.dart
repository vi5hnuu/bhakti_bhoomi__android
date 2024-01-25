import 'package:bhakti_bhoomi/models/mantra/MantraInfoModel.dart';
import 'package:bhakti_bhoomi/models/mantra/MantraModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:dio/dio.dart';

abstract class MantraService {
  Future<ApiResponse<List<MantraInfoModel>>> getAllMantraInfo({CancelToken? cancelToken});
  Future<ApiResponse<List<MantraModel>>> getAllMantra({CancelToken? cancelToken});
  Future<ApiResponse<MantraModel>> getMantraById({required String id, CancelToken? cancelToken});
  Future<ApiResponse<MantraModel>> getMantraByTitle({required String title, CancelToken? cancelToken});
}
