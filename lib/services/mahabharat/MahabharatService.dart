import 'package:bhakti_bhoomi/models/mahabharat/MahabharatBookInfoModel.dart';
import 'package:bhakti_bhoomi/models/mahabharat/MahabharatShlokModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';

abstract class MahabharatService {
  Future<ApiResponse<List<MahabharatBookInfoModel>>> getMahabharatInfo();
  Future<ApiResponse<MahabharatShlokModel>> getMahabharatShlokById({required String id});
  Future<ApiResponse<MahabharatShlokModel>> getMahabharatShlokByShlokNo({required int bookNo, required int chapterNo, required int shlokNo});
  Future<ApiResponse<List<MahabharatShlokModel>>> getMahabharatShloksByBookChapter({required int bookNo, required int chapterNo, int? pageNo, int? pageSize});
}
