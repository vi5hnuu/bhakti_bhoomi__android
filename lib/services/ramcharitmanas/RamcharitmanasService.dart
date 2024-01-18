import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasMangalacharanModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasVerseModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';

abstract class RamcharitmanasService {
  Future<ApiResponse<RamcharitmanasInfoModel>> getRamcharitmanasInfo();
  Future<ApiResponse<RamcharitmanasVerseModel>> getRamcharitmanasVerseById({required String id, String? lang});
  Future<ApiResponse<RamcharitmanasVerseModel>> getRamcharitmanasVerseByKandaAndVerseNo({required String kanda, required int verseNo, String? lang});
  Future<ApiResponse<RamcharitmanasMangalacharanModel>> getRamcharitmanasMangalacharanByKanda({required String kanda, String? lang});
  Future<ApiResponse<List<RamcharitmanasMangalacharanModel>>> getRamcharitmanasAllMangalacharan({String? lang});
  Future<ApiResponse<List<RamcharitmanasVerseModel>>> getRamcharitmanasVersesByKand({required String kanda, String? lang, int? pageNo, int? pageSize});
}
