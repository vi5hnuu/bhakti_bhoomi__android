class RamcharitmanasModelInfo {
  final Map<String, String> translationLanguages;
  final int totalMangalacharan;
  final Map<String, int> kandaInfo;
  final Map<String, int> kandaMapping;

  const RamcharitmanasModelInfo({
    required this.translationLanguages,
    required this.totalMangalacharan,
    required this.kandaInfo,
    required this.kandaMapping,
  });

  factory RamcharitmanasModelInfo.fromJson(Map<String, dynamic> json) {
    return RamcharitmanasModelInfo(
      translationLanguages: Map<String, String>.from(json['translationLanguages'].map((key, value) => MapEntry<String, String>(key, value))),
      totalMangalacharan: json['totalMangalacharan'],
      kandaInfo: Map<String, int>.from(json['kandaInfo'].map((key, value) => MapEntry<String, int>(key, int.parse(value)))),
      kandaMapping: Map<String, int>.from(json['kandaMapping'].map((key, value) => MapEntry<String, int>(key, value))),
    );
  }
}
