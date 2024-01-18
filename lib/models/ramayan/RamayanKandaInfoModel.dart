import 'package:bhakti_bhoomi/models/ramayan/RamayanSargaInfoModel.dart';

class RamayanKandaInfoModel {
  final String kanda;
  final int totalSarga;
  final Map<String, RamayanSargaInfoModel> info;

  const RamayanKandaInfoModel({
    required this.kanda,
    required this.totalSarga,
    required this.info,
  });

  factory RamayanKandaInfoModel.fromJson(Map<String, dynamic> json) {
    return RamayanKandaInfoModel(
      kanda: json['kanda'],
      totalSarga: json['totalSarga'],
      info: Map<String, RamayanSargaInfoModel>.from(json['info'].map((key, value) => MapEntry<String, RamayanSargaInfoModel>(key, RamayanSargaInfoModel.fromJson(value)))),
    );
  }
}
