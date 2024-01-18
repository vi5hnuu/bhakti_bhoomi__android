import 'package:bhakti_bhoomi/models/chalisa/ChalisaInfoModel.dart';
import 'package:bhakti_bhoomi/models/chalisa/ChalisaModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/ChalisaApi.dart';
import 'package:bhakti_bhoomi/services/chalisa/ChalisaService.dart';

class ChalisaRepository implements ChalisaService {
  final ChalisaApi chalisaApi;
  static final ChalisaRepository _instance = ChalisaRepository._();

  ChalisaRepository._() : chalisaApi = ChalisaApi();
  factory ChalisaRepository() => _instance;

  @override
  Future<ApiResponse<List<ChalisaModel>>> getAllChalisa() async {
    final res = await chalisaApi.getAllChalisa();
    return ApiResponse<List<ChalisaModel>>(success: res['success'], data: res['data'].map((e) => ChalisaModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<List<ChalisaInfoModel>>> getAllChalisaInfo() async {
    final res = await chalisaApi.getAllChalisaInfo();
    return ApiResponse<List<ChalisaInfoModel>>(success: res['success'], data: res['data'].map((e) => ChalisaInfoModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<ChalisaModel>> getChalisaById({required String id}) async {
    final res = await chalisaApi.getChalisaById(id: id);
    return ApiResponse<ChalisaModel>(success: res['success'], data: ChalisaModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<ChalisaModel>> getChalisaByTitle({required String title}) async {
    final res = await chalisaApi.getChalisaByTitle(title: title);
    return ApiResponse<ChalisaModel>(success: res['success'], data: ChalisaModel.fromJson(res['data']));
  }
}
