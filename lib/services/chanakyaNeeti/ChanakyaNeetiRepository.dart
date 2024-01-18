import 'package:bhakti_bhoomi/models/chanakyaNeeti/ChanakyaNeetiChapterInfoModel.dart';
import 'package:bhakti_bhoomi/models/chanakyaNeeti/ChanakyaNeetiVerseModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/ChanakyaNeetiApi.dart';

import 'ChanakyaNeetiService.dart';

class ChanakyaNeetiRepository implements ChanakyaNeetiService {
  final ChanakyaNeetiApi chanakyaNeetiApi;
  static final ChanakyaNeetiRepository _instance = ChanakyaNeetiRepository._();

  ChanakyaNeetiRepository._() : chanakyaNeetiApi = ChanakyaNeetiApi();
  factory ChanakyaNeetiRepository() => _instance;

  @override
  Future<ApiResponse<List<ChanakyaNeetiVerseModel>>> getchanakyaNeetiChapterVerses({required int chapterNo}) async {
    final res = await chanakyaNeetiApi.getchanakyaNeetiChapterVerses(chapterNo: chapterNo);
    return ApiResponse<List<ChanakyaNeetiVerseModel>>(success: res['success'], data: res['data'].map((e) => ChanakyaNeetiVerseModel.fromJson(res['data'])));
  }

  @override
  Future<ApiResponse<List<ChanakyaNeetiChapterInfoModel>>> getchanakyaNeetiChaptersInfo() async {
    final res = await chanakyaNeetiApi.getchanakyaNeetiChaptersInfo();
    return ApiResponse<List<ChanakyaNeetiChapterInfoModel>>(success: res['success'], data: res['data'].map((e) => ChanakyaNeetiChapterInfoModel.fromJson(res['data'])));
  }

  @override
  Future<ApiResponse<ChanakyaNeetiVerseModel>> getchanakyaNeetiVerseByChapterNoVerseNo({required int chapterNo, required int verseNo}) async {
    final res = await chanakyaNeetiApi.getchanakyaNeetiVerseByChapterNoVerseNo(chapterNo: chapterNo, verseNo: verseNo);
    return ApiResponse<ChanakyaNeetiVerseModel>(success: res['success'], data: ChanakyaNeetiVerseModel.fromJson(res['data']));
  }
}
