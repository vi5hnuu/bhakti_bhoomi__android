import 'package:bhakti_bhoomi/models/mantra/MantraAudioModel.dart';
import 'package:bhakti_bhoomi/models/mantra/MantraAudioPageModel.dart';
import 'package:bhakti_bhoomi/models/mantra/MantraGroupModel.dart';
import 'package:bhakti_bhoomi/models/mantra/MantraInfoModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:dio/dio.dart';

abstract class MantraService {
  Future<ApiResponse<List<MantraInfoModel>>> getAllMantraInfo({CancelToken? cancelToken});
  Future<ApiResponse<MantraAudioPageModel>> getAllMantraAudioInfo({int? pageNo,int? pageSize,CancelToken? cancelToken});
  Future<ApiResponse<List<MantraGroupModel>>> getAllMantra({CancelToken? cancelToken});
  Future<ApiResponse<MantraGroupModel>> getMantraById({required String id, CancelToken? cancelToken});
  Future<ApiResponse<MantraGroupModel>> getMantraByTitle({required String title, CancelToken? cancelToken});
  Future<ApiResponse<MantraAudioModel>> getMantraAudioById({required String id, CancelToken? cancelToken});
  Future<ApiResponse<MantraAudioModel>> getMantraAudioByTitle({required String title, CancelToken? cancelToken});
}
