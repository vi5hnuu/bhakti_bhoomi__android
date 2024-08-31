import 'package:bhakti_bhoomi/models/aarti/AartiInfoModel.dart';
import 'package:bhakti_bhoomi/models/aarti/AartiModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/models/vratKatha/VratkathaInfoModel.dart';
import 'package:bhakti_bhoomi/models/vratKatha/VratkathaInfoPageModel.dart';
import 'package:bhakti_bhoomi/models/vratKatha/VratkathaModel.dart';
import 'package:dio/dio.dart';

abstract class AartiService {
  Future<ApiResponse<VratkathaInfoPageModel>> getVratKathaInfoPage({required pageNo,required pageSize,CancelToken? cancelToken});
  Future<ApiResponse<VratkathaInfoModel>> getVratKathInfo({required String kathaId, CancelToken? cancelToken});
  Future<ApiResponse<VratkathaModel>> getVratKathaById({required String kathaId, CancelToken? cancelToken});
  Future<ApiResponse<VratkathaModel>> getVratKathaByTitle({required String kathaTitle, CancelToken? cancelToken});
}
