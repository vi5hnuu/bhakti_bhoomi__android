import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/models/rigveda/RigvedaInfoModel.dart';
import 'package:bhakti_bhoomi/models/rigveda/RigvedaVerseModel.dart';

abstract class RigvedaService {
  Future<ApiResponse<RigvedaInfoModel>> getRigvedaInfo();
  Future<ApiResponse<RigvedaVerseModel>> getVerseByMandalaSukta({required int mandalaNo, required int suktaNo});
  Future<ApiResponse<RigvedaVerseModel>> getVerseBySuktaId({required String suktaId});
  Future<ApiResponse<List<RigvedaVerseModel>>> getVersesByMandala({required int mandalaNo, int? pageNo, int? pageSize});
}
