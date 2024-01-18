import 'package:bhakti_bhoomi/services/apis/BhagvadGeetaApi.dart';
import 'package:bhakti_bhoomi/services/bhagvadGeeta/BhagvadGeetaService.dart';

class BhagvadGeetaRepository implements BhagvadGeetaService {
  final BhagvadGeetaApi bhagvadGeetaApi;
  static final BhagvadGeetaRepository _instance = BhagvadGeetaRepository._();

  BhagvadGeetaRepository._() : bhagvadGeetaApi = BhagvadGeetaApi();
  factory BhagvadGeetaRepository() => _instance;
}
