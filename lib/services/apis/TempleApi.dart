import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:bhakti_bhoomi/singletons/DioSingleton.dart';

class TempleApi {
  static final TempleApi _instance = TempleApi._();
  static const String _base = "${ApiConstants.baseUrl}/temples";

  TempleApi._();
  factory TempleApi() => _instance;

  Future<List<dynamic>> list({String? state}) async {
    final res = await DioSingleton().dio.get(_base, queryParameters: {if (state != null) 'state': state});
    return List<dynamic>.from(res.data['data'] ?? []);
  }
}
