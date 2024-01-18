import 'package:bhakti_bhoomi/models/chanakyaNeeti/ChanakyaNeetiChapterInfoModel.dart';
import 'package:bhakti_bhoomi/models/chanakyaNeeti/ChanakyaNeetiVerseModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';

abstract class ChanakyaNeetiService {
  Future<ApiResponse<List<ChanakyaNeetiChapterInfoModel>>> getchanakyaNeetiChaptersInfo();
  Future<ApiResponse<List<ChanakyaNeetiVerseModel>>> getchanakyaNeetiChapterVerses({required int chapterNo});
  Future<ApiResponse<ChanakyaNeetiVerseModel>> getchanakyaNeetiVerseByChapterNoVerseNo({required int chapterNo, required int verseNo});
}
