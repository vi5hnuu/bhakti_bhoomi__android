import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:bhakti_bhoomi/singletons/DioSingleton.dart';

class DailyVerseApi {
  static final DailyVerseApi _instance = DailyVerseApi._();
  static const String _dailyVerseUrl = "${ApiConstants.baseUrl}/daily-verse";

  DailyVerseApi._();
  factory DailyVerseApi() => _instance;

  Future<Map<String, dynamic>> getDailyVerse() async {
    final res = await DioSingleton().dio.get(_dailyVerseUrl);
    return res.data;
  }
}
