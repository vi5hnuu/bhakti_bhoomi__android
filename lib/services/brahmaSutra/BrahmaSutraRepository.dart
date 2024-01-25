import 'package:bhakti_bhoomi/models/brahmaSutra/BrahmaSutraInfoModel.dart';
import 'package:bhakti_bhoomi/models/brahmaSutra/BrahmaSutraModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/BrahmasutraApi.dart';
import 'package:bhakti_bhoomi/services/brahmaSutra/BrahmaSutraService.dart';
import 'package:dio/dio.dart';

class BrahmaSutraRepository implements BrahmaSutraService {
  final BrahmasutraApi _brahmasutraApi;
  static final BrahmaSutraRepository _instance = BrahmaSutraRepository._();

  BrahmaSutraRepository._() : _brahmasutraApi = BrahmasutraApi();
  factory BrahmaSutraRepository() => _instance;

  @override
  Future<ApiResponse<BrahmaSutraModel>> getBrahmasutraBySutraId({required String sutraId, String? lang, CancelToken? cancelToken}) async {
    final res = await _brahmasutraApi.getBrahmasutraBySutraId(sutraId: sutraId, lang: lang, cancelToken: cancelToken);
    return ApiResponse<BrahmaSutraModel>(success: res['success'], data: BrahmaSutraModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<BrahmaSutraModel>> getbrahmasutraByChapterNoQuaterNoSutraNo({required int chapterNo, required int quaterNo, required int sutraNo, String? lang, CancelToken? cancelToken}) async {
    final res = await _brahmasutraApi.getbrahmasutraByChapterNoQuaterNoSutraNo(chapterNo: chapterNo, quaterNo: quaterNo, sutraNo: sutraNo, lang: lang, cancelToken: cancelToken);
    return ApiResponse<BrahmaSutraModel>(success: res['success'], data: BrahmaSutraModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<BrahmasutraInfoModel>> getBrahmasutraInfo({CancelToken? cancelToken}) async {
    final res = await _brahmasutraApi.getBrahmasutraInfo(cancelToken: cancelToken);
    return ApiResponse<BrahmasutraInfoModel>(success: res['success'], data: BrahmasutraInfoModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<BrahmaSutraModel>>> getbrahmasutrasByChapterNoQuaterNo(
      {required int chapterNo, required int quaterNo, int? pageNo, int? pageSize, String? lang, CancelToken? cancelToken}) async {
    final res = await _brahmasutraApi.getbrahmasutrasByChapterNoQuaterNo(chapterNo: chapterNo, quaterNo: quaterNo, pageNo: pageNo, pageSize: pageSize, lang: lang, cancelToken: cancelToken);
    return ApiResponse<List<BrahmaSutraModel>>(success: res['success'], data: res['data'].map((e) => BrahmaSutraModel.fromJson(e)).toList());
  }
}
