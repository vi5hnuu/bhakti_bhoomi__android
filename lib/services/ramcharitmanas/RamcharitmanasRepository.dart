import 'package:bhakti_bhoomi/services/apis/RamcharitmanasApi.dart';

import 'RamcharitmanasService.dart';

class RamcharitmanasRepository implements RamcharitmanasService {
  final RamcharitmanasApi ramcharitmanasApi;
  static final RamcharitmanasRepository _instance = RamcharitmanasRepository._();

  RamcharitmanasRepository._() : ramcharitmanasApi = RamcharitmanasApi();
  factory RamcharitmanasRepository() => _instance;
}
