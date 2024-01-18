import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/models/yogaSutra/YogaSutraInfoModel.dart';
import 'package:bhakti_bhoomi/models/yogaSutra/YogaSutraModel.dart';
import 'package:bhakti_bhoomi/services/apis/YogasutraApi.dart';
import 'package:bhakti_bhoomi/services/yogasutra/YogaSutraService.dart';

class YogaSutraRepository implements YogaSutraService {
  final YogasutraApi yogasutraApi;
  static final YogaSutraRepository _instance = YogaSutraRepository._();

  YogaSutraRepository._() : yogasutraApi = YogasutraApi();
  factory YogaSutraRepository() => _instance;

  @override
  Future<ApiResponse<YogaSutraModel>> getYogasutraByChapterNoSutraNo({required int chapterNo, required int sutraNo, String? lang}) async {
    final res = await yogasutraApi.getYogasutraByChapterNoSutraNo(chapterNo: chapterNo, sutraNo: sutraNo, lang: lang);
    return ApiResponse<YogaSutraModel>(success: res['success'], data: YogaSutraModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<YogaSutraModel>> getYogasutraBySutraId({required String sutraId, String? lang}) async {
    final res = await yogasutraApi.getYogasutraBySutraId(sutraId: sutraId, lang: lang);
    return ApiResponse<YogaSutraModel>(success: res['success'], data: YogaSutraModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<YogaSutraModel>>> getYogasutrasByChapterNo({required int chapterNo, int? pageNo, int? pageSize, String? lang}) async {
    final res = await yogasutraApi.getYogasutrasByChapterNo(chapterNo: chapterNo, pageNo: pageNo, pageSize: pageSize, lang: lang);
    return ApiResponse<List<YogaSutraModel>>(success: res['success'], data: res['data'].map((e) => YogaSutraModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<YogaSutraInfoModel>> getyogasutraInfo() async {
    final res = await yogasutraApi.getyogasutraInfo();
    return ApiResponse<YogaSutraInfoModel>(success: res['success'], data: YogaSutraInfoModel.fromJson(res['data']));
  }
}
