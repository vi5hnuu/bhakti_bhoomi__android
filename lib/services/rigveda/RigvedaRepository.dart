import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/models/rigveda/RigvedaInfoModel.dart';
import 'package:bhakti_bhoomi/models/rigveda/RigvedaVerseModel.dart';
import 'package:bhakti_bhoomi/services/apis/RigvedaApi.dart';
import 'package:bhakti_bhoomi/services/rigveda/RigvedaService.dart';

class RigvedaRepository implements RigvedaService {
  final RigvedaApi rigvedaApi;
  static final RigvedaRepository _instance = RigvedaRepository._();

  RigvedaRepository._() : rigvedaApi = RigvedaApi();
  factory RigvedaRepository() => _instance;

  @override
  Future<ApiResponse<RigvedaInfoModel>> getRigvedaInfo() async {
    final res = await rigvedaApi.getRigvedaInfo();
    return ApiResponse<RigvedaInfoModel>(success: res['data'], data: RigvedaInfoModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<RigvedaVerseModel>> getVerseByMandalaSukta({required int mandalaNo, required int suktaNo}) async {
    final res = await rigvedaApi.getVerseByMandalaSukta(mandalaNo: mandalaNo, suktaNo: suktaNo);
    return ApiResponse<RigvedaVerseModel>(success: res['data'], data: RigvedaVerseModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<RigvedaVerseModel>> getVerseBySuktaId({required String suktaId}) async {
    final res = await rigvedaApi.getVerseBySuktaId(suktaId: suktaId);
    return ApiResponse<RigvedaVerseModel>(success: res['data'], data: RigvedaVerseModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<RigvedaVerseModel>>> getVersesByMandala({required int mandalaNo, int? pageNo, int? pageSize}) async {
    final res = await rigvedaApi.getVersesByMandala(mandalaNo: mandalaNo, pageNo: pageNo, pageSize: pageSize);
    return ApiResponse<List<RigvedaVerseModel>>(success: res['data'], data: res['data'].map((e) => RigvedaVerseModel.fromJson(e)).toList());
  }
}
