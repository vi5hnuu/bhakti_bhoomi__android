import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasMangalacharanModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasVerseModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/RamcharitmanasApi.dart';
import 'package:dio/dio.dart';

import 'RamcharitmanasService.dart';

class RamcharitmanasRepository implements RamcharitmanasService {
  final RamcharitmanasApi _ramcharitmanasApi;
  static final RamcharitmanasRepository _instance = RamcharitmanasRepository._();

  RamcharitmanasRepository._() : _ramcharitmanasApi = RamcharitmanasApi();
  factory RamcharitmanasRepository() => _instance;

  @override
  Future<ApiResponse<List<RamcharitmanasMangalacharanModel>>> getRamcharitmanasAllMangalacharan({String? lang, CancelToken? cancelToken}) async {
    final res = await _ramcharitmanasApi.getRamcharitmanasAllMangalacharan(lang: lang, cancelToken: cancelToken);
    return ApiResponse<List<RamcharitmanasMangalacharanModel>>(success: res['success'], data: res['data'].map((e) => RamcharitmanasMangalacharanModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<RamcharitmanasInfoModel>> getRamcharitmanasInfo({CancelToken? cancelToken}) async {
    final res = await _ramcharitmanasApi.getRamcharitmanasInfo(cancelToken: cancelToken);
    return ApiResponse<RamcharitmanasInfoModel>(success: res['success'], data: RamcharitmanasInfoModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<RamcharitmanasMangalacharanModel>> getRamcharitmanasMangalacharanByKanda({required String kanda, String? lang, CancelToken? cancelToken}) async {
    final res = await _ramcharitmanasApi.getRamcharitmanasMangalacharanByKanda(kanda: kanda, lang: lang, cancelToken: cancelToken);
    return ApiResponse<RamcharitmanasMangalacharanModel>(success: res['success'], data: RamcharitmanasMangalacharanModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<RamcharitmanasVerseModel>> getRamcharitmanasVerseById({required String id, String? lang, CancelToken? cancelToken}) async {
    final res = await _ramcharitmanasApi.getRamcharitmanasVerseById(id: id, lang: lang, cancelToken: cancelToken);
    return ApiResponse<RamcharitmanasVerseModel>(success: res['success'], data: RamcharitmanasVerseModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<RamcharitmanasVerseModel>> getRamcharitmanasVerseByKandaAndVerseNo({required String kanda, required int verseNo, String? lang, CancelToken? cancelToken}) async {
    final res = await _ramcharitmanasApi.getRamcharitmanasVerseByKandaAndVerseNo(kanda: kanda, verseNo: verseNo, lang: lang, cancelToken: cancelToken);
    return ApiResponse<RamcharitmanasVerseModel>(success: res['success'], data: RamcharitmanasVerseModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<RamcharitmanasVerseModel>>> getRamcharitmanasVersesByKand({required String kanda, String? lang, int? pageNo, int? pageSize, CancelToken? cancelToken}) async {
    final res = await _ramcharitmanasApi.getRamcharitmanasVersesByKand(kanda: kanda, lang: lang, pageNo: pageNo, pageSize: pageSize, cancelToken: cancelToken);
    return ApiResponse<List<RamcharitmanasVerseModel>>(success: res['success'], data: res['data'].map((e) => RamcharitmanasVerseModel.fromJson(e)).toList());
  }
}
