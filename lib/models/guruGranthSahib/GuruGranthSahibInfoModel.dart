import 'package:bhakti_bhoomi/models/guruGranthSahib/GuruGranthSahibRagaInfoModel.dart';

class GuruGranthSahibInfoModel {
  String description;
  List<GuruGranthSahibRagaInfoModel> ragasInfo;

  GuruGranthSahibInfoModel({required this.description, required this.ragasInfo});

  factory GuruGranthSahibInfoModel.fromJson(Map<String, dynamic> json) {
    return GuruGranthSahibInfoModel(
      description: json['description'],
      ragasInfo: List<GuruGranthSahibRagaInfoModel>.from((json['ragasInfo'] as List<dynamic>).map((ragaInfo) => GuruGranthSahibRagaInfoModel.fromJson(ragaInfo))),
    );
  }
}
