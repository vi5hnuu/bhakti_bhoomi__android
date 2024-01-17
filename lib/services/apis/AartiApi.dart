import 'package:bhakti_bhoomi/services/ApiConstants.dart';
import 'package:dio/dio.dart';

class AartiApi {
  static final AartiApi _instance = AartiApi._();

  static final String _allAartiUrl = "${ApiConstants.baseUrl}/aarti/all"; //GET
  static final String _allAartiInfoUrl = "${ApiConstants.baseUrl}/aarti/all/info"; //GET
  static final String _aartiByIdOrTitleUrl = "${ApiConstants.baseUrl}/aarti"; //GET

  AartiApi._();
  factory AartiApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getAllAartiInfo() async {
    var res = await Dio().get(_allAartiInfoUrl);
    return res.data;
  }

  Future<Map<String, dynamic>> getAllAarti() async {
    var res = await Dio().get(_allAartiUrl);
    return res.data;
  }

  Future<Map<String, dynamic>> getAartiById({required String id}) async {
    var res = await Dio().get('$_aartiByIdOrTitleUrl?id=$id');
    return res.data;
  }

  Future<Map<String, dynamic>> getAartiByTitle({required String title}) async {
    var res = await Dio().get('$_aartiByIdOrTitleUrl?title=$title');
    return res.data;
  }
}
