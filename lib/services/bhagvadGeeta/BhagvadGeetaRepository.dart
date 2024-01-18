import 'package:bhakti_bhoomi/models/bhagvadGeeta/BHagvadGeetaChapterModel.dart';
import 'package:bhakti_bhoomi/models/bhagvadGeeta/BhagvadGeetaShlokModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/BhagvadGeetaApi.dart';
import 'package:bhakti_bhoomi/services/bhagvadGeeta/BhagvadGeetaService.dart';

class BhagvadGeetaRepository implements BhagvadGeetaService {
  final BhagvadGeetaApi bhagvadGeetaApi;
  static final BhagvadGeetaRepository _instance = BhagvadGeetaRepository._();

  BhagvadGeetaRepository._() : bhagvadGeetaApi = BhagvadGeetaApi();
  factory BhagvadGeetaRepository() => _instance;

  @override
  Future<ApiResponse<BhagvadGeetaChapterModel>> getbhagvadGeetaChapter({required String chapterId}) async {
    final res = await bhagvadGeetaApi.getbhagvadGeetaChapter(chapterId: chapterId);
    return ApiResponse<BhagvadGeetaChapterModel>(success: res['success'], data: BhagvadGeetaChapterModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<BhagvadGeetaChapterModel>>> getbhagvadGeetaChapters() async {
    final res = await bhagvadGeetaApi.getbhagvadGeetaChapters();
    return ApiResponse<List<BhagvadGeetaChapterModel>>(success: res['success'], data: res['data'].map((e) => BhagvadGeetaChapterModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<List<BhagvadGeetaShlokModel>>> getbhagvadGeetaShloks({required String chapterId, int? pageNo, int? pageSize}) async {
    final res = await bhagvadGeetaApi.getbhagvadGeetaShloks(chapterId: chapterId, pageNo: pageNo, pageSize: pageSize);
    return ApiResponse<List<BhagvadGeetaShlokModel>>(success: res['success'], data: res['data'].map((e) => BhagvadGeetaShlokModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<BhagvadGeetaShlokModel>> getbhagvadShlokByChapterIdShlokId({required String chapterId, required String shlokId}) async {
    final res = await bhagvadGeetaApi.getbhagvadShlokByChapterIdShlokId(chapterId: chapterId, shlokId: shlokId);
    return ApiResponse<BhagvadGeetaShlokModel>(success: res['success'], data: BhagvadGeetaShlokModel.fromJson(res['data']));
  }
}
