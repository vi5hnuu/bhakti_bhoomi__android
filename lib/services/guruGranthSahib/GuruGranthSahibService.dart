import 'package:bhakti_bhoomi/models/aarti/AartiInfoModel.dart';
import 'package:bhakti_bhoomi/models/aarti/AartiModel.dart';
import 'package:bhakti_bhoomi/models/guruGranthSahib/GuruGranthSahibInfoModel.dart';
import 'package:bhakti_bhoomi/models/guruGranthSahib/GuruGranthSahibRagaModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:dio/dio.dart';

abstract class GuruGranthSahibService {
  Future<ApiResponse<GuruGranthSahibInfoModel>> getInfo({CancelToken? cancelToken});
  Future<ApiResponse<GuruGranthSahibRagaModel>> getRagaByRagaNoPartNo({required int ragaNo,required int partNo,CancelToken? cancelToken});
  Future<ApiResponse<GuruGranthSahibRagaModel>> getRagaByRagaNoPartId({required int ragaNo,required String partId,CancelToken? cancelToken});
  Future<ApiResponse<GuruGranthSahibRagaModel>> getRagaByRagaNamePartNo({required String ragaName,required int partNo,CancelToken? cancelToken});
  Future<ApiResponse<GuruGranthSahibRagaModel>> getRagaByRagaNamePartId({required String ragaName,required String partId,CancelToken? cancelToken});
  Future<ApiResponse<String>> getDescription({CancelToken? cancelToken});
}
