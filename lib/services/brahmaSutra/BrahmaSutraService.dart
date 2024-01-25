import 'package:bhakti_bhoomi/models/brahmaSutra/BrahmaSutraInfoModel.dart';
import 'package:bhakti_bhoomi/models/brahmaSutra/BrahmaSutraModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:dio/dio.dart';

abstract class BrahmaSutraService {
  Future<ApiResponse<BrahmasutraInfoModel>> getBrahmasutraInfo({CancelToken? cancelToken});
  Future<ApiResponse<BrahmaSutraModel>> getBrahmasutraBySutraId({required String sutraId, String? lang, CancelToken? cancelToken});
  Future<ApiResponse<BrahmaSutraModel>> getbrahmasutraByChapterNoQuaterNoSutraNo({required int chapterNo, required int quaterNo, required int sutraNo, String? lang, CancelToken? cancelToken});
  Future<ApiResponse<List<BrahmaSutraModel>>> getbrahmasutrasByChapterNoQuaterNo({required int chapterNo, required int quaterNo, int? pageNo, int? pageSize, String? lang, CancelToken? cancelToken});
}
