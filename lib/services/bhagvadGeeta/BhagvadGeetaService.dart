import 'package:bhakti_bhoomi/models/bhagvadGeeta/BHagvadGeetaChapterModel.dart';
import 'package:bhakti_bhoomi/models/bhagvadGeeta/BhagvadGeetaShlokModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:dio/dio.dart';

abstract class BhagvadGeetaService {
  Future<ApiResponse<List<BhagvadGeetaChapterModel>>> getbhagvadGeetaChapters({CancelToken? cancelToken});
  Future<ApiResponse<BhagvadGeetaChapterModel>> getbhagvadGeetaChapter({required String chapterId, CancelToken? cancelToken});
  Future<ApiResponse<BhagvadGeetaShlokModel>> getbhagvadShlokByChapterIdShlokId({required String chapterId, required String shlokId, CancelToken? cancelToken});
  Future<ApiResponse<List<BhagvadGeetaShlokModel>>> getbhagvadGeetaShloks({required String chapterId, int? pageNo, int? pageSize, CancelToken? cancelToken});
}
