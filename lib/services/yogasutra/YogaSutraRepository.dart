import 'package:bhakti_bhoomi/services/apis/YogasutraApi.dart';
import 'package:bhakti_bhoomi/services/yogasutra/YogaSutraService.dart';

class YogaSutraRepository implements YogaSutraService {
  final YogasutraApi yogasutraApi;
  static final YogaSutraRepository _instance = YogaSutraRepository._();

  YogaSutraRepository._() : yogasutraApi = YogasutraApi();
  factory YogaSutraRepository() => _instance;
}
