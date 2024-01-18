import 'package:bhakti_bhoomi/models/bhagvadGeeta/BHagvadGeetaChapterModel.dart';
import 'package:bhakti_bhoomi/models/bhagvadGeeta/BhagvadGeetaShlokModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';

abstract class BhagvadGeetaService {
  Future<ApiResponse<List<BhagvadGeetaChapterModel>>> getbhagvadGeetaChapters();
  Future<ApiResponse<BhagvadGeetaChapterModel>> getbhagvadGeetaChapter({required String chapterId});
  Future<ApiResponse<BhagvadGeetaShlokModel>> getbhagvadShlokByChapterIdShlokId({required String chapterId, required String shlokId});
  Future<ApiResponse<List<BhagvadGeetaShlokModel>>> getbhagvadGeetaShloks({required String chapterId, int? pageNo, int? pageSize});
}
