import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/models/yogaSutra/YogaSutraInfoModel.dart';
import 'package:bhakti_bhoomi/models/yogaSutra/YogaSutraModel.dart';

abstract class YogaSutraService {
  Future<ApiResponse<YogaSutraInfoModel>> getyogasutraInfo();
  Future<ApiResponse<YogaSutraModel>> getYogasutraBySutraId({required String sutraId, String? lang});
  Future<ApiResponse<YogaSutraModel>> getYogasutraByChapterNoSutraNo({required int chapterNo, required int sutraNo, String? lang});
  Future<ApiResponse<List<YogaSutraModel>>> getYogasutrasByChapterNo({required int chapterNo, int? pageNo, int? pageSize, String? lang});
}
