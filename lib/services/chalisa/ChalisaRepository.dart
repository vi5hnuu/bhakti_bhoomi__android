import 'package:bhakti_bhoomi/models/chalisa/ChalisaInfoModel.dart';
import 'package:bhakti_bhoomi/models/chalisa/ChalisaModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/ChalisaApi.dart';
import 'package:bhakti_bhoomi/services/chalisa/ChalisaService.dart';
import 'package:dio/dio.dart';

class ChalisaRepository implements ChalisaService {
  final ChalisaApi _chalisaApi;
  static final ChalisaRepository _instance = ChalisaRepository._();

  ChalisaRepository._() : _chalisaApi = ChalisaApi();
  factory ChalisaRepository() => _instance;

  @override
  Future<ApiResponse<List<ChalisaModel>>> getAllChalisa({CancelToken? cancelToken}) async {
    final res = await _chalisaApi.getAllChalisa(cancelToken: cancelToken);
    return ApiResponse<List<ChalisaModel>>(success: res['success'], data: res['data'].map((e) => ChalisaModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<List<ChalisaInfoModel>>> getAllChalisaInfo({CancelToken? cancelToken}) async {
    final res = await _chalisaApi.getAllChalisaInfo(cancelToken: cancelToken);
    return ApiResponse<List<ChalisaInfoModel>>(success: res['success'], data: (res['data'] as List).map((e) => ChalisaInfoModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<ChalisaModel>> getChalisaById({required String id, CancelToken? cancelToken}) async {
    final res = await _chalisaApi.getChalisaById(id: id, cancelToken: cancelToken);
    return ApiResponse<ChalisaModel>(success: res['success'], data: ChalisaModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<ChalisaModel>> getChalisaByTitle({required String title, CancelToken? cancelToken}) async {
    final res = await _chalisaApi.getChalisaByTitle(title: title, cancelToken: cancelToken);
    return ApiResponse<ChalisaModel>(success: res['success'], data: ChalisaModel.fromJson(res['data']));
  }
}
