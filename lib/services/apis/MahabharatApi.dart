import 'package:bhakti_bhoomi/services/ApiConstants.dart';
import 'package:dio/dio.dart';

class MahabharatApi {
  static final MahabharatApi _instance = MahabharatApi._();

  static final String _mahabharatInfoUrl = "${ApiConstants.baseUrl}/mahabharat/info"; //GET
  static final String _mahabharatShlokByIdUrl = "${ApiConstants.baseUrl}/mahabharat/shlok"; //GET
  static final String _mahabharatShloksByBookChapterUrl = "${ApiConstants.baseUrl}/mahabharat/book/%bookNo%/chapter/%chapterNo%"; //GET
  static final String _mahabharatShlokByShlokNoUrl = "${ApiConstants.baseUrl}/mahabharat/book/%bookNo%/chapter/%chapterNo%/shlok/%shlokNo%"; //GET

  MahabharatApi._();
  factory MahabharatApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getMahabharatInfo() async {
    var res = await Dio().get(_mahabharatInfoUrl);
    return res.data;
  }

  Future<Map<String, dynamic>> getMahabharatShlokById({required String id}) async {
    var res = await Dio().get('$_mahabharatShlokByIdUrl?id=$id');
    return res.data;
  }

  Future<Map<String, dynamic>> getMahabharatByShlokNo({required int bookNo, required int chapterNo, required int shlokNo}) async {
    var url = _mahabharatShlokByShlokNoUrl.replaceAll("%bookNo%", '$bookNo').replaceAll("%chapterNo%", '$chapterNo').replaceAll("%shlokNo%", '$shlokNo');
    var res = await Dio().get(url);
    return res.data;
  }

  Future<Map<String, dynamic>> getMahabharatShloksByBookChapter({required int bookNo, required int chapterNo, int? pageNo, int? pageSize}) async {
    var url = _mahabharatShloksByBookChapterUrl.replaceAll("%bookNo%", '$bookNo').replaceAll("%chapterNo%", '$chapterNo');
    if (pageNo != null) {
      url += '?pageNo=$pageNo';
    }
    if (pageSize != null) {
      url = pageNo != null ? '&pageSize=$pageSize' : '?pageSize=$pageSize';
    }
    var res = await Dio().get(url);
    return res.data;
  }
}
