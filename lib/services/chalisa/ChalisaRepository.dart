import 'package:bhakti_bhoomi/services/apis/ChalisaApi.dart';
import 'package:bhakti_bhoomi/services/chalisa/ChalisaService.dart';

class ChalisaRepository implements ChalisaService {
  final ChalisaApi chalisaApi;
  static final ChalisaRepository _instance = ChalisaRepository._();

  ChalisaRepository._() : chalisaApi = ChalisaApi();
  factory ChalisaRepository() => _instance;
}
