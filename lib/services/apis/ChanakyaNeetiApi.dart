import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:dio/dio.dart';

import '../../singletons/DioSingleton.dart';

class ChanakyaNeetiApi {
  static final ChanakyaNeetiApi _instance = ChanakyaNeetiApi._();

  static final String _chanakyaNeetiChaptersInfoUrl = "${ApiConstants.baseUrl}/chanakya_neeti/chapters"; //GET
  static final String _chanakyaNeetiVersesByChapterNoUrl = "${ApiConstants.baseUrl}/chanakya_neeti/chapter/%chapterNo%"; //GET
  static final String _chanakyaNeetiVerseByChapterNoVerseNoUrl = "${ApiConstants.baseUrl}/chanakya_neeti/chapter/%chapterNo%/%verseNo%"; //GET

  ChanakyaNeetiApi._();
  factory ChanakyaNeetiApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getchanakyaNeetiChaptersInfo({CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get(_chanakyaNeetiChaptersInfoUrl, cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getchanakyaNeetiChapterVerses({required int chapterNo, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get('$_chanakyaNeetiVersesByChapterNoUrl/$chapterNo', cancelToken: cancelToken);
    return res.data;
  }

  Future<Map<String, dynamic>> getchanakyaNeetiVerseByChapterNoVerseNo({required int chapterNo, required int verseNo, CancelToken? cancelToken}) async {
    var res = await DioSingleton().dio.get('$_chanakyaNeetiVerseByChapterNoVerseNoUrl/$chapterNo/$verseNo', cancelToken: cancelToken);
    return res.data;
  }
}
