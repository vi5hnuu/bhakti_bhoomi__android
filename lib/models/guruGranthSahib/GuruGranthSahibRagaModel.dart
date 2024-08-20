
import 'package:bhakti_bhoomi/models/guruGranthSahib/GuruGranthSahibEntryType.dart';

class GuruGranthSahibRagaModel {
  String id;
  GuruGranthSahibEntryType type;
  int ragaNo;
  String ragaName;
  int partNo;
  List<String> text;

  GuruGranthSahibRagaModel({required this.id, required this.type, required this.ragaNo, required this.ragaName, required this.partNo, required this.text});

  factory GuruGranthSahibRagaModel.fromJson(Map<String, dynamic> json) {
    return GuruGranthSahibRagaModel(
      id: json['id'],
      type: GuruGranthSahibEntryType.values.firstWhere((e) => e.type == json['type']),
      partNo: json['partNo'],
      ragaNo: json['ragaNo'],
      ragaName: json['ragaName'],
      text: List<String>.from((json['text'] as List<dynamic>).map((text) => text as String)),
    );
  }
}