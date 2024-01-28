class RamayanInfoModel {
  final Map<String, int> kandaOrder;
  final Map<String, String> translationLanguages;
  final Map<String, int> kandInfo;

  const RamayanInfoModel({
    required this.kandaOrder,
    required this.translationLanguages,
    required this.kandInfo,
  });

  factory RamayanInfoModel.fromJson(Map<String, dynamic> json) {
    return RamayanInfoModel(
      translationLanguages: Map<String, String>.from(json['translationLanguages'].map((key, value) => MapEntry<String, String>(key, value))),
      kandaOrder: Map<String, int>.from(json['kandaOrder'].map((key, value) => MapEntry<String, int>(key, value))),
      kandInfo: Map<String, int>.from(json['kandInfo'].map((key, value) => MapEntry<String, int>(key, value))),
    );
  }
}
