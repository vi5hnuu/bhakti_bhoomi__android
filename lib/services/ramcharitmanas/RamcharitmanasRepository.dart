import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasInfoModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasMangalacharanModel.dart';
import 'package:bhakti_bhoomi/models/ramcharitmanas/RamcharitmanasVerseModel.dart';
import 'package:bhakti_bhoomi/models/response/ApiResponse.dart';
import 'package:bhakti_bhoomi/services/apis/RamcharitmanasApi.dart';

import 'RamcharitmanasService.dart';

class RamcharitmanasRepository implements RamcharitmanasService {
  final RamcharitmanasApi ramcharitmanasApi;
  static final RamcharitmanasRepository _instance = RamcharitmanasRepository._();

  RamcharitmanasRepository._() : ramcharitmanasApi = RamcharitmanasApi();
  factory RamcharitmanasRepository() => _instance;

  @override
  Future<ApiResponse<List<RamcharitmanasMangalacharanModel>>> getRamcharitmanasAllMangalacharan({String? lang}) async {
    final res = await ramcharitmanasApi.getRamcharitmanasAllMangalacharan(lang: lang);
    return ApiResponse<List<RamcharitmanasMangalacharanModel>>(success: res['success'], data: res['data'].map((e) => RamcharitmanasMangalacharanModel.fromJson(e)).toList());
  }

  @override
  Future<ApiResponse<RamcharitmanasInfoModel>> getRamcharitmanasInfo() async {
    final res = await ramcharitmanasApi.getRamcharitmanasInfo();
    return ApiResponse<RamcharitmanasInfoModel>(success: res['success'], data: RamcharitmanasInfoModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<RamcharitmanasMangalacharanModel>> getRamcharitmanasMangalacharanByKanda({required String kanda, String? lang}) async {
    final res = await ramcharitmanasApi.getRamcharitmanasMangalacharanByKanda(kanda: kanda, lang: lang);
    return ApiResponse<RamcharitmanasMangalacharanModel>(success: res['success'], data: RamcharitmanasMangalacharanModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<RamcharitmanasVerseModel>> getRamcharitmanasVerseById({required String id, String? lang}) async {
    final res = await ramcharitmanasApi.getRamcharitmanasVerseById(id: id, lang: lang);
    return ApiResponse<RamcharitmanasVerseModel>(success: res['success'], data: RamcharitmanasVerseModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<RamcharitmanasVerseModel>> getRamcharitmanasVerseByKandaAndVerseNo({required String kanda, required int verseNo, String? lang}) async {
    final res = await ramcharitmanasApi.getRamcharitmanasVerseByKandaAndVerseNo(kanda: kanda, verseNo: verseNo, lang: lang);
    return ApiResponse<RamcharitmanasVerseModel>(success: res['success'], data: RamcharitmanasVerseModel.fromJson(res['data']));
  }

  @override
  Future<ApiResponse<List<RamcharitmanasVerseModel>>> getRamcharitmanasVersesByKand({required String kanda, String? lang, int? pageNo, int? pageSize}) async {
    final res = await ramcharitmanasApi.getRamcharitmanasVersesByKand(kanda: kanda, lang: lang, pageNo: pageNo, pageSize: pageSize);
    return ApiResponse<List<RamcharitmanasVerseModel>>(success: res['success'], data: res['data'].map((e) => RamcharitmanasVerseModel.fromJson(e)).toList());
  }
}
