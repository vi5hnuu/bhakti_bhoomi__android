import 'package:bhakti_bhoomi/models/chanakyaNeeti/ChanakyaNeetiChapterInfoModel.dart';
import 'package:bhakti_bhoomi/models/chanakyaNeeti/ChanakyaNeetiVerseModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:dio/dio.dart';

abstract class ChanakyaNeetiService {
  Future<ApiResponse<List<ChanakyaNeetiChapterInfoModel>>> getchanakyaNeetiChaptersInfo({CancelToken? cancelToken});
  Future<ApiResponse<List<ChanakyaNeetiVerseModel>>> getchanakyaNeetiChapterVerses({required int chapterNo, CancelToken? cancelToken});
  Future<ApiResponse<ChanakyaNeetiVerseModel>> getchanakyaNeetiVerseByChapterNoVerseNo({required int chapterNo, required int verseNo, CancelToken? cancelToken});
}
