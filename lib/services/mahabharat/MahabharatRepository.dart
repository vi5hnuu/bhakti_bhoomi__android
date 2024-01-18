import 'package:bhakti_bhoomi/models/mahabharat/MahabharatBookInfoModel.dart';
import 'package:bhakti_bhoomi/models/mahabharat/MahabharatShlokModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/MahabharatApi.dart';

import 'MahabharatService.dart';

class MahabharatRepository implements MahabharatService {
  final MahabharatApi mahabharatApi;
  static final MahabharatRepository _instance = MahabharatRepository._();

  MahabharatRepository._() : mahabharatApi = MahabharatApi();
  factory MahabharatRepository() => _instance;

  @override
  Future<ApiResponse<MahabharatShlokModel>> getMahabharatShlokByShlokNo({required int bookNo, required int chapterNo, required int shlokNo}) async {
    final res = await mahabharatApi.getMahabharatShlokByShlokNo(bookNo: bookNo, chapterNo: chapterNo, shlokNo: shlokNo);
    return ApiResponse<MahabharatShlokModel>(success: res['success'], data: MahabharatShlokModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<MahabharatBookInfoModel>>> getMahabharatInfo() async {
    final res = await mahabharatApi.getMahabharatInfo();
    return ApiResponse<List<MahabharatBookInfoModel>>(success: res['success'], data: res['data'].map((e) => MahabharatBookInfoModel.fromJson(res['data'])));
  }

  @override
  Future<ApiResponse<MahabharatShlokModel>> getMahabharatShlokById({required String id}) async {
    final res = await mahabharatApi.getMahabharatShlokById(id: id);
    return ApiResponse<MahabharatShlokModel>(success: res['success'], data: MahabharatShlokModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<MahabharatShlokModel>>> getMahabharatShloksByBookChapter({required int bookNo, required int chapterNo, int? pageNo, int? pageSize}) async {
    final res = await mahabharatApi.getMahabharatShloksByBookChapter(bookNo: bookNo, chapterNo: chapterNo, pageNo: pageNo, pageSize: pageSize);
    return ApiResponse<List<MahabharatShlokModel>>(success: res['success'], data: res['data'].map((e) => MahabharatShlokModel.fromJson(res['data'])));
  }
}
