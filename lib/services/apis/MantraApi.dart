import 'package:bhakti_bhoomi/services/ApiConstants.dart';
import 'package:dio/dio.dart';

class MantraApi {
  static final MantraApi _instance = MantraApi._();

  static final String _allMantraUrl = "${ApiConstants.baseUrl}/mantra/all"; //GET
  static final String _allMantraInfoUrl = "${ApiConstants.baseUrl}/mantra/all/info"; //GET
  static final String _mantraByIdOrTitleUrl = "${ApiConstants.baseUrl}/mantra"; //GET

  MantraApi._();
  factory MantraApi() {
    return _instance;
  }

  Future<Map<String, dynamic>> getAllMantraInfo() async {
    var res = await Dio().get(_allMantraInfoUrl);
    return res.data;
  }

  Future<Map<String, dynamic>> getAllMantra() async {
    var res = await Dio().get(_allMantraUrl);
    return res.data;
  }

  Future<Map<String, dynamic>> getMantraById({required String id}) async {
    var res = await Dio().get('$_mantraByIdOrTitleUrl?id=$id');
    return res.data;
  }

  Future<Map<String, dynamic>> getMantraByTitle({required String title}) async {
    var res = await Dio().get('$_mantraByIdOrTitleUrl?title=$title');
    return res.data;
  }
}
