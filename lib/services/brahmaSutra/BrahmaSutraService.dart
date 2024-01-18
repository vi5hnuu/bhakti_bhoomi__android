import 'package:bhakti_bhoomi/models/brahmaSutra/BrahmaSutraInfoModel.dart';
import 'package:bhakti_bhoomi/models/brahmaSutra/BrahmaSutraModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';

abstract class BrahmaSutraService {
  Future<ApiResponse<BrahmasutraInfoModel>> getBrahmasutraInfo();
  Future<ApiResponse<BrahmaSutraModel>> getBrahmasutraBySutraId({required String sutraId, String? lang});
  Future<ApiResponse<BrahmaSutraModel>> getbrahmasutraByChapterNoQuaterNoSutraNo({required int chapterNo, required int quaterNo, required int sutraNo, String? lang});
  Future<ApiResponse<List<BrahmaSutraModel>>> getbrahmasutrasByChapterNoQuaterNo({required int chapterNo, required int quaterNo, int? pageNo, int? pageSize, String? lang});
}
