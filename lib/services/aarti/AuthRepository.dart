import 'package:bhakti_bhoomi/services/apis/AartiApi.dart';

import 'AartiService.dart';

class AartiRepository implements AartiService {
  final AartiApi aartiApi;
  static final AartiRepository _instance = AartiRepository._();

  AartiRepository._() : aartiApi = AartiApi();
  factory AartiRepository() => _instance;
}
