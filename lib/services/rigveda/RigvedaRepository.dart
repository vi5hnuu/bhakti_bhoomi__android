import 'package:bhakti_bhoomi/services/apis/RigvedaApi.dart';
import 'package:bhakti_bhoomi/services/rigveda/RigvedaService.dart';

class RigvedaRepository implements RigvedaService {
  final RigvedaApi rigvedaApi;
  static final RigvedaRepository _instance = RigvedaRepository._();

  RigvedaRepository._() : rigvedaApi = RigvedaApi();
  factory RigvedaRepository() => _instance;
}
