class YogaSutraInfoModel {
  final Map<String, String> translationLanguages;
  final Map<String, int> totalSutra;

  const YogaSutraInfoModel({
    required this.translationLanguages,
    required this.totalSutra,
  });

  factory YogaSutraInfoModel.fromJson(Map<String, dynamic> json) {
    return YogaSutraInfoModel(
      translationLanguages: Map<String, String>.from(json['translationLanguages'].map((key, value) => MapEntry<String, String>(key, value))),
      totalSutra: Map<String, int>.from(json['totalSutra'].map((key, value) => MapEntry<String, int>(key, value))),
    );
  }
}
