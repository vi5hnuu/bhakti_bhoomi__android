import 'package:bhakti_bhoomi/models/guruGranthSahib/GuruGranthSahibEntryType.dart';

class GuruGranthSahibRagaInfoModel {
  int totalParts;
  int ragaNo;
  String name;
  GuruGranthSahibEntryType type;

  GuruGranthSahibRagaInfoModel({required this.totalParts, required this.ragaNo, required this.name, required this.type});

  factory GuruGranthSahibRagaInfoModel.fromJson(Map<String, dynamic> json) {
    return GuruGranthSahibRagaInfoModel(
      totalParts: json['totalParts'],
      ragaNo: json['ragaNo'],
      name: json['name'],
      type: GuruGranthSahibEntryType.values.firstWhere((e)=>e.type==json['type']),
    );
  }
}
