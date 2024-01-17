import 'package:bhakti_bhoomi/services/ApiConstants.dart';
import 'package:dio/dio.dart';

class ChanakyaNeetiApi {
  static final ChanakyaNeetiApi _instance = ChanakyaNeetiApi._();

  static final String _chanakyaNeetiChaptersInfoUrl = "${ApiConstants.baseUrl}/chanakya_neeti/chapters"; //GET
  static final String _chanakyaNeetiVersesByChapterNoUrl = "${ApiConstants.baseUrl}/chanakya_neeti/chapter/%chapterNo%"; //GET
  static final String _chanakyaNeetiVerseByChapterNoVerseNoUrl = "${ApiConstants.baseUrl}/chanakya_neeti/chapter/%chapterNo%/%verseNo%"; //GET

  ChanakyaNeetiApi._();
  factory ChanakyaNeetiApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getchanakyaNeetiChaptersInfo() async {
    var res = await Dio().get(_chanakyaNeetiChaptersInfoUrl);
    return res.data;
  }

  Future<Map<String, dynamic>> getchanakyaNeetiChapterVerses({required int chapterNo}) async {
    var res = await Dio().get('$_chanakyaNeetiVersesByChapterNoUrl/$chapterNo');
    return res.data;
  }

  Future<Map<String, dynamic>> getchanakyaNeetiVerseByChapterNoVerseNo({required int chapterNo, required int verseNo}) async {
    var res = await Dio().get('$_chanakyaNeetiVerseByChapterNoVerseNoUrl/$chapterNo/$verseNo');
    return res.data;
  }
}
