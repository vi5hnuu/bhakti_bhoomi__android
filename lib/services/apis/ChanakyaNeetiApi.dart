import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class ChanakyaNeetiApi {
  static final ChanakyaNeetiApi _instance = ChanakyaNeetiApi._();

  static const String _chanakyaNeetiChaptersInfoUrl = "${ApiConstants.baseUrl}/chanakya_neeti/chapters/info"; //GET
  static const String _chanakyaNeetiVersesByChapterNoUrl = "${ApiConstants.baseUrl}/chanakya_neeti/chapterNo/%chapterNo%/verses"; //GET
  static const String _chanakyaNeetiVerseByChapterNoVerseNoUrl = "${ApiConstants.baseUrl}/chanakya_neeti/chapterNo/%chapterNo%/verseNo/%verseNo%"; //GET

  ChanakyaNeetiApi._();
  factory ChanakyaNeetiApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getchanakyaNeetiChaptersInfo({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_chanakyaNeetiChaptersInfoUrl, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getchanakyaNeetiChapterVerses({required int chapterNo, CancelToken? cancelToken}) async {
    final url = _chanakyaNeetiVersesByChapterNoUrl.replaceAll("%chapterNo%", '$chapterNo');
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getchanakyaNeetiVerseByChapterNoVerseNo({required int chapterNo, required int verseNo, CancelToken? cancelToken}) async {
    final url = _chanakyaNeetiVerseByChapterNoVerseNoUrl.replaceAll("%chapterNo%", '$chapterNo').replaceAll("%verseNo%", '$verseNo');
    var res = await DioSingleton().dio.get(url, cancelToken: cancelToken);
    return res.data;
  }
}
