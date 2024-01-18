import 'package:bhakti_bhoomi/services/apis/ChanakyaNeetiApi.dart';

import 'ChanakyaNeetiService.dart';

class ChanakyaNeetiRepository implements ChanakyaNeetiService {
  final ChanakyaNeetiApi chanakyaNeetiApi;
  static final ChanakyaNeetiRepository _instance = ChanakyaNeetiRepository._();

  ChanakyaNeetiRepository._() : chanakyaNeetiApi = ChanakyaNeetiApi();
  factory ChanakyaNeetiRepository() => _instance;
}
