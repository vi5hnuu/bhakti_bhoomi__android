import 'package:bhakti_bhoomi/models/chanakyaNeeti/ChanakyaNeetiChapterInfoModel.dart';
import 'package:bhakti_bhoomi/models/chanakyaNeeti/ChanakyaNeetiVerseModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/ChanakyaNeetiApi.dart';
import 'package:dio/dio.dart';

import 'ChanakyaNeetiService.dart';

class ChanakyaNeetiRepository implements ChanakyaNeetiService {
  final ChanakyaNeetiApi _chanakyaNeetiApi;
  static final ChanakyaNeetiRepository _instance = ChanakyaNeetiRepository._();

  ChanakyaNeetiRepository._() : _chanakyaNeetiApi = ChanakyaNeetiApi();
  factory ChanakyaNeetiRepository() => _instance;

  @override
  Future<ApiResponse<List<ChanakyaNeetiVerseModel>>> getchanakyaNeetiChapterVerses({required int chapterNo, CancelToken? cancelToken}) async {
    final res = await _chanakyaNeetiApi.getchanakyaNeetiChapterVerses(chapterNo: chapterNo, cancelToken: cancelToken);
    return ApiResponse<List<ChanakyaNeetiVerseModel>>(success: res['success'], data: res['data'].map((e) => ChanakyaNeetiVerseModel.fromJson(e)));
  }

  @override
  Future<ApiResponse<List<ChanakyaNeetiChapterInfoModel>>> getchanakyaNeetiChaptersInfo({CancelToken? cancelToken}) async {
    final res = await _chanakyaNeetiApi.getchanakyaNeetiChaptersInfo(cancelToken: cancelToken);
    return ApiResponse<List<ChanakyaNeetiChapterInfoModel>>(success: res['success'], data: (res['data'] as List).map((e) => ChanakyaNeetiChapterInfoModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<ChanakyaNeetiVerseModel>> getchanakyaNeetiVerseByChapterNoVerseNo({required int chapterNo, required int verseNo, CancelToken? cancelToken}) async {
    final res = await _chanakyaNeetiApi.getchanakyaNeetiVerseByChapterNoVerseNo(chapterNo: chapterNo, verseNo: verseNo, cancelToken: cancelToken);
    return ApiResponse<ChanakyaNeetiVerseModel>(success: res['success'], data: ChanakyaNeetiVerseModel.fromJson(res['data']));
  }
}
