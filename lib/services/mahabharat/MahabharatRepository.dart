import 'package:bhakti_bhoomi/services/apis/AuthApi.dart';

import 'MahabharatService.dart';

class MahabharatRepository implements MahabharatService {
  final AuthApi authApi;
  static final MahabharatRepository _instance = MahabharatRepository._();

  MahabharatRepository._() : authApi = AuthApi();
  factory MahabharatRepository() => _instance;
}
