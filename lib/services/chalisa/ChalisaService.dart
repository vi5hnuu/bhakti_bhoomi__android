import 'package:bhakti_bhoomi/models/chalisa/ChalisaInfoModel.dart';
import 'package:bhakti_bhoomi/models/chalisa/ChalisaModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';

abstract class ChalisaService {
  Future<ApiResponse<List<ChalisaInfoModel>>> getAllChalisaInfo();
  Future<ApiResponse<List<ChalisaModel>>> getAllChalisa();
  Future<ApiResponse<ChalisaModel>> getChalisaById({required String id});
  Future<ApiResponse<ChalisaModel>> getChalisaByTitle({required String title});
}
