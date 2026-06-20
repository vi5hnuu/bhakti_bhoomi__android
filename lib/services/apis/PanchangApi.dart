import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:bhakti_bhoomi/singletons/DioSingleton.dart';

class PanchangApi {
  static final PanchangApi _instance = PanchangApi._();
  static const String _base = "${ApiConstants.baseUrl}/panchang";

  PanchangApi._();
  factory PanchangApi() => _instance;

  /// Panchang for [date] (defaults to today). Location defaults to the backend's
  /// reference meridian when lat/lng are omitted.
  Future<Map<String, dynamic>> getPanchang({DateTime? date, double? lat, double? lng}) async {
    final res = await DioSingleton().dio.get(_base, queryParameters: {
      if (date != null) 'date': date.toIso8601String().split('T').first,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    });
    return Map<String, dynamic>.from(res.data);
  }

  Future<List<dynamic>> getFestivals({int? year}) async {
    final res = await DioSingleton().dio.get('$_base/festivals', queryParameters: {if (year != null) 'year': year});
    return List<dynamic>.from(res.data);
  }
}
