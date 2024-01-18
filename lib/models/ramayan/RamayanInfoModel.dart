import 'package:bhakti_bhoomi/models/ramayan/RamayanKandaInfoModel.dart';

class RamayanInfoModel {
  final Map<String, int> kandaOrder;
  final Map<String, RamayanKandaInfoModel> kandInfo;

  const RamayanInfoModel({
    required this.kandaOrder,
    required this.kandInfo,
  });

  factory RamayanInfoModel.fromJson(Map<String, dynamic> json) {
    return RamayanInfoModel(
      kandaOrder: Map<String, int>.from(json['kandaOrder'].map((key, value) => MapEntry<String, int>(key, value))),
      kandInfo: Map<String, RamayanKandaInfoModel>.from(json['kandInfo'].map((key, value) => MapEntry<String, RamayanKandaInfoModel>(key, RamayanKandaInfoModel.fromJson(value)))),
    );
  }
}
