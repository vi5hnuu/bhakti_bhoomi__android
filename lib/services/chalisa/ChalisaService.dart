import 'package:bhakti_bhoomi/models/chalisa/ChalisaInfoModel.dart';
import 'package:bhakti_bhoomi/models/chalisa/ChalisaModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:dio/dio.dart';

abstract class ChalisaService {
  Future<ApiResponse<List<ChalisaInfoModel>>> getAllChalisaInfo({CancelToken? cancelToken});
  Future<ApiResponse<List<ChalisaModel>>> getAllChalisa({CancelToken? cancelToken});
  Future<ApiResponse<ChalisaModel>> getChalisaById({required String id, CancelToken? cancelToken});
  Future<ApiResponse<ChalisaModel>> getChalisaByTitle({required String title, CancelToken? cancelToken});
}
