class RamcharitmanasInfoModel {
  final Map<String, String> versesTranslationLanguages;
  final Map<String, String> mangalacharanTranslationLanguages;
  final int totalMangalacharan;
  final Map<String, int> kandaInfo;
  final Map<String, int> kandaMapping;

  const RamcharitmanasInfoModel({
    required this.versesTranslationLanguages,
    required this.mangalacharanTranslationLanguages,
    required this.totalMangalacharan,
    required this.kandaInfo,
    required this.kandaMapping,
  });

  factory RamcharitmanasInfoModel.fromJson(Map<String, dynamic> json) {
    return RamcharitmanasInfoModel(
      versesTranslationLanguages: Map<String, String>.from(json['versesTranslationLanguages'].map((key, value) => MapEntry<String, String>(key, value))),
      mangalacharanTranslationLanguages: Map<String, String>.from(json['mangalacharanTranslationLanguages'].map((key, value) => MapEntry<String, String>(key, value))),
      totalMangalacharan: json['totalMangalacharan'],
      kandaInfo: Map<String, int>.from(json['kandaInfo'].map((key, value) => MapEntry<String, int>(key, int.parse(value)))),
      kandaMapping: Map<String, int>.from(json['kandaMapping'].map((key, value) => MapEntry<String, int>(key, value))),
    );
  }
}
