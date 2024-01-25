import 'package:bhakti_bhoomi/models/mahabharat/MahabharatBookInfoModel.dart';
import 'package:bhakti_bhoomi/models/mahabharat/MahabharatShlokModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:dio/dio.dart';

abstract class MahabharatService {
  Future<ApiResponse<List<MahabharatBookInfoModel>>> getMahabharatInfo({CancelToken? cancelToken});
  Future<ApiResponse<MahabharatShlokModel>> getMahabharatShlokById({required String id, CancelToken? cancelToken});
  Future<ApiResponse<MahabharatShlokModel>> getMahabharatShlokByShlokNo({required int bookNo, required int chapterNo, required int shlokNo, CancelToken? cancelToken});
  Future<ApiResponse<List<MahabharatShlokModel>>> getMahabharatShloksByBookChapter({required int bookNo, required int chapterNo, int? pageNo, int? pageSize, CancelToken? cancelToken});
}
