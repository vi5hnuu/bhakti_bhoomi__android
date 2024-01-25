import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/models/yogaSutra/YogaSutraInfoModel.dart';
import 'package:bhakti_bhoomi/models/yogaSutra/YogaSutraModel.dart';
import 'package:bhakti_bhoomi/services/apis/YogasutraApi.dart';
import 'package:bhakti_bhoomi/services/yogasutra/YogaSutraService.dart';
import 'package:dio/dio.dart';

class YogaSutraRepository implements YogaSutraService {
  final YogasutraApi _yogasutraApi;
  static final YogaSutraRepository _instance = YogaSutraRepository._();

  YogaSutraRepository._() : _yogasutraApi = YogasutraApi();
  factory YogaSutraRepository() => _instance;

  @override
  Future<ApiResponse<YogaSutraModel>> getYogasutraByChapterNoSutraNo({required int chapterNo, required int sutraNo, String? lang, CancelToken? cancelToken}) async {
    final res = await _yogasutraApi.getYogasutraByChapterNoSutraNo(chapterNo: chapterNo, sutraNo: sutraNo, lang: lang, cancelToken: cancelToken);
    return ApiResponse<YogaSutraModel>(success: res['success'], data: YogaSutraModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<YogaSutraModel>> getYogasutraBySutraId({required String sutraId, String? lang, CancelToken? cancelToken}) async {
    final res = await _yogasutraApi.getYogasutraBySutraId(sutraId: sutraId, lang: lang, cancelToken: cancelToken);
    return ApiResponse<YogaSutraModel>(success: res['success'], data: YogaSutraModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<YogaSutraModel>>> getYogasutrasByChapterNo({required int chapterNo, int? pageNo, int? pageSize, String? lang, CancelToken? cancelToken}) async {
    final res = await _yogasutraApi.getYogasutrasByChapterNo(chapterNo: chapterNo, pageNo: pageNo, pageSize: pageSize, lang: lang, cancelToken: cancelToken);
    return ApiResponse<List<YogaSutraModel>>(success: res['success'], data: res['data'].map((e) => YogaSutraModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<YogaSutraInfoModel>> getyogasutraInfo({CancelToken? cancelToken}) async {
    final res = await _yogasutraApi.getyogasutraInfo(cancelToken: cancelToken);
    return ApiResponse<YogaSutraInfoModel>(success: res['success'], data: YogaSutraInfoModel.fromJson(res['data']));
  }
}
