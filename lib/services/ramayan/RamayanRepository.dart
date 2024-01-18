import 'package:bhakti_bhoomi/services/apis/RamayanApi.dart';

import 'RamayanService.dart';

class RamayanRepository implements RamayanService {
  final RamayanApi ramayanApi;
  static final RamayanRepository _instance = RamayanRepository._();

  RamayanRepository._() : ramayanApi = RamayanApi();
  factory RamayanRepository() => _instance;
}
