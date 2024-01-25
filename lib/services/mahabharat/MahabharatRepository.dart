import 'package:bhakti_bhoomi/models/mahabharat/MahabharatBookInfoModel.dart';
import 'package:bhakti_bhoomi/models/mahabharat/MahabharatShlokModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/MahabharatApi.dart';
import 'package:dio/dio.dart';

import 'MahabharatService.dart';

class MahabharatRepository implements MahabharatService {
  final MahabharatApi _mahabharatApi;
  static final MahabharatRepository _instance = MahabharatRepository._();

  MahabharatRepository._() : _mahabharatApi = MahabharatApi();
  factory MahabharatRepository() => _instance;

  @override
  Future<ApiResponse<MahabharatShlokModel>> getMahabharatShlokByShlokNo({required int bookNo, required int chapterNo, required int shlokNo, CancelToken? cancelToken}) async {
    final res = await _mahabharatApi.getMahabharatShlokByShlokNo(bookNo: bookNo, chapterNo: chapterNo, shlokNo: shlokNo, cancelToken: cancelToken);
    return ApiResponse<MahabharatShlokModel>(success: res['success'], data: MahabharatShlokModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<MahabharatBookInfoModel>>> getMahabharatInfo({CancelToken? cancelToken}) async {
    final res = await _mahabharatApi.getMahabharatInfo(cancelToken: cancelToken);
    return ApiResponse<List<MahabharatBookInfoModel>>(success: res['success'], data: (res['data'] as List).map((e) => MahabharatBookInfoModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<MahabharatShlokModel>> getMahabharatShlokById({required String id, CancelToken? cancelToken}) async {
    final res = await _mahabharatApi.getMahabharatShlokById(id: id, cancelToken: cancelToken);
    return ApiResponse<MahabharatShlokModel>(success: res['success'], data: MahabharatShlokModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<MahabharatShlokModel>>> getMahabharatShloksByBookChapter({required int bookNo, required int chapterNo, int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    final res = await _mahabharatApi.getMahabharatShloksByBookChapter(bookNo: bookNo, chapterNo: chapterNo, pageNo: pageNo, pageSize: pageSize, cancelToken: cancelToken);
    return ApiResponse<List<MahabharatShlokModel>>(success: res['success'], data: ((res['data'] as Map<String, dynamic>)['content'] as List).map((e) => MahabharatShlokModel.fromJson(e)).toList());
  }
}
