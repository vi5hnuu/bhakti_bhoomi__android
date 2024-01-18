import 'package:bhakti_bhoomi/services/apis/MantraApi.dart';

import 'AuthService.dart';

class MantraRepository implements MantraService {
  final MantraApi mantraApi;
  static final MantraRepository _instance = MantraRepository._();

  MantraRepository._() : mantraApi = MantraApi();
  factory MantraRepository() => _instance;
}
