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
  Future<ApiResponse<List<BhagvadGeetaChapterModel>>> getbhagvadGeetaChapters({CancelToken? cancelToken}) async {
    final res = await _bhagvadGeetaApi.getbhagvadGeetaChapters(cancelToken: cancelToken);
    final List<BhagvadGeetaChapterModel> chapters = (res['data'] as List).map((e) => BhagvadGeetaChapterModel.fromJson(e)).toList();
    chapters.sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
    return ApiResponse<List<BhagvadGeetaChapterModel>>(success: res['success'], data: chapters);
  }

  @override
  Future<ApiResponse<List<BhagvadGeetaShlokModel>>> getbhagvadGeetaShloks({required String chapterId, int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    final res = await _bhagvadGeetaApi.getbhagvadGeetaShloks(chapterId: chapterId, pageNo: pageNo, pageSize: pageSize, cancelToken: cancelToken);
    return ApiResponse<List<BhagvadGeetaShlokModel>>(success: res['success'], data: res['data'].map((e) => BhagvadGeetaShlokModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<BhagvadGeetaShlokModel>> getbhagvadShlokByChapterIdShlokId({required String chapterId, required String shlokId, CancelToken? cancelToken}) async {
    final res = await _bhagvadGeetaApi.getbhagvadShlokByChapterIdShlokId(chapterId: chapterId, shlokId: shlokId, cancelToken: cancelToken);
    return ApiResponse<BhagvadGeetaShlokModel>(success: res['success'], data: BhagvadGeetaShlokModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<BhagvadGeetaShlokModel>> getbhagvadShlokByChapterIdShlokNo({required String chapterId, required int shlokNo, CancelToken? cancelToken}) async {
    final res = await _bhagvadGeetaApi.getbhagvadShlokByChapterIdShlokNo(chapterId: chapterId, shlokNo: shlokNo, cancelToken: cancelToken);
    return ApiResponse<BhagvadGeetaShlokModel>(success: res['success'], data: BhagvadGeetaShlokModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<BhagvadGeetaShlokModel>> getbhagvadShlokByChapterNoShlokNo({required int chapterNo, required int shlokNo, CancelToken? cancelToken}) async {
    final res = await _bhagvadGeetaApi.getbhagvadShlokByChapterNoShlokNo(chapterNo: chapterNo, shlokNo: shlokNo, cancelToken: cancelToken);
    return ApiResponse<BhagvadGeetaShlokModel>(success: res['success'], data: BhagvadGeetaShlokModel.fromJson(res['data']));
  }
}
