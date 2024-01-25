import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasMangalacharanModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasVerseModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:dio/dio.dart';

abstract class RamcharitmanasService {
  Future<ApiResponse<RamcharitmanasInfoModel>> getRamcharitmanasInfo({CancelToken? cancelToken});
  Future<ApiResponse<RamcharitmanasVerseModel>> getRamcharitmanasVerseById({required String id, String? lang, CancelToken? cancelToken});
  Future<ApiResponse<RamcharitmanasVerseModel>> getRamcharitmanasVerseByKandaAndVerseNo({required String kanda, required int verseNo, String? lang, CancelToken? cancelToken});
  Future<ApiResponse<RamcharitmanasMangalacharanModel>> getRamcharitmanasMangalacharanByKanda({required String kanda, String? lang, CancelToken? cancelToken});
  Future<ApiResponse<List<RamcharitmanasMangalacharanModel>>> getRamcharitmanasAllMangalacharan({String? lang, CancelToken? cancelToken});
  Future<ApiResponse<List<RamcharitmanasVerseModel>>> getRamcharitmanasVersesByKand({required String kanda, String? lang, int? pageNo, int? pageSize, CancelToken? cancelToken});
}
