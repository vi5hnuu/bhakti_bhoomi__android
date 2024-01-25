import 'package:bhakti_bhoomi/models/bhagvadGeeta/BHagvadGeetaChapterModel.dart';
import 'package:bhakti_bhoomi/models/bhagvadGeeta/BhagvadGeetaShlokModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/BhagvadGeetaApi.dart';
import 'package:bhakti_bhoomi/services/bhagvadGeeta/BhagvadGeetaService.dart';
import 'package:dio/dio.dart';

class BhagvadGeetaRepository implements BhagvadGeetaService {
  final BhagvadGeetaApi _bhagvadGeetaApi;
  static final BhagvadGeetaRepository _instance = BhagvadGeetaRepository._();

  BhagvadGeetaRepository._() : _bhagvadGeetaApi = BhagvadGeetaApi();
  factory BhagvadGeetaRepository() => _instance;

  @override
  Future<ApiResponse<BhagvadGeetaChapterModel>> getbhagvadGeetaChapter({required String chapterId, CancelToken? cancelToken}) async {
    final res = await _bhagvadGeetaApi.getbhagvadGeetaChapter(chapterId: chapterId);
    return ApiResponse<BhagvadGeetaChapterModel>(success: res['success'], data: BhagvadGeetaChapterModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<BhagvadGeetaChapterModel>>> getbhagvadGeetaChapters({CancelToken? cancelToken}) async {
    final res = await _bhagvadGeetaApi.getbhagvadGeetaChapters();
    return ApiResponse<List<BhagvadGeetaChapterModel>>(success: res['success'], data: res['data'].map((e) => BhagvadGeetaChapterModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<List<BhagvadGeetaShlokModel>>> getbhagvadGeetaShloks({required String chapterId, int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    final res = await _bhagvadGeetaApi.getbhagvadGeetaShloks(chapterId: chapterId, pageNo: pageNo, pageSize: pageSize);
    return ApiResponse<List<BhagvadGeetaShlokModel>>(success: res['success'], data: res['data'].map((e) => BhagvadGeetaShlokModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<BhagvadGeetaShlokModel>> getbhagvadShlokByChapterIdShlokId({required String chapterId, required String shlokId, CancelToken? cancelToken}) async {
    final res = await _bhagvadGeetaApi.getbhagvadShlokByChapterIdShlokId(chapterId: chapterId, shlokId: shlokId);
    return ApiResponse<BhagvadGeetaShlokModel>(success: res['success'], data: BhagvadGeetaShlokModel.fromJson(res['data']));
  }
}
