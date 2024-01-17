import 'package:bhakti_bhoomi/services/ApiConstants.dart';
import 'package:dio/dio.dart';

class ChalisaApi {
  static final ChalisaApi _instance = ChalisaApi._();

  static final String _allChalisaUrl = "${ApiConstants.baseUrl}/chalisa/all"; //GET
  static final String _allChalisaInfoUrl = "${ApiConstants.baseUrl}/chalisa/all/info"; //GET
  static final String _chalisaByIdOrTitleUrl = "${ApiConstants.baseUrl}/chalisa"; //GET

  ChalisaApi._();
  factory ChalisaApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getAllChalisaInfo() async {
    var res = await Dio().get(_allChalisaInfoUrl);
    return res.data;
  }

  Future<Map<String, dynamic>> getAllChalisa() async {
    var res = await Dio().get(_allChalisaUrl);
    return res.data;
  }

  Future<Map<String, dynamic>> getchalisaById({required String id}) async {
    var res = await Dio().get('$_chalisaByIdOrTitleUrl?id=$id');
    return res.data;
  }

  Future<Map<String, dynamic>> getchalisaByTitle({required String title}) async {
    var res = await Dio().get('$_chalisaByIdOrTitleUrl?title=$title');
    return res.data;
  }
}
