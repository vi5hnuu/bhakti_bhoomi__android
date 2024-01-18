class BrahmaSutraModel {
  final String id;
  final int chapterNo;
  final int quaterNo;
  final int sutraNo;
  final Map<String, String> sutra;
  final String language;

  const BrahmaSutraModel({
    required this.id,
    required this.chapterNo,
    required this.quaterNo,
    required this.sutraNo,
    required this.sutra,
    required this.language,
  });

  factory BrahmaSutraModel.fromJson(Map<String, dynamic> json) {
    return BrahmaSutraModel(
      id: json['id'],
      chapterNo: json['chapterNo'],
      quaterNo: json['quaterNo'],
      sutraNo: json['sutraNo'],
      sutra: Map<String, String>.from(json['sutra'].map((key, value) => MapEntry<String, String>(key, value))),
      language: json['language'],
    );
  }
}
