class YogaSutraModel {
  final String id;
  final int chapterNo;
  final int sutraNo;
  final Map<String, String> sutra;
  final String language;

  const YogaSutraModel({
    required this.id,
    required this.chapterNo,
    required this.sutraNo,
    required this.sutra,
    required this.language,
  });

  factory YogaSutraModel.fromJson(Map<String, dynamic> json) {
    return YogaSutraModel(
      id: json['id'],
      chapterNo: json['chapterNo'],
      sutraNo: json['sutraNo'],
      sutra: Map<String, String>.from(json['sutra'].map((key, value) => MapEntry<String, String>(key, value))),
      language: json['language'],
    );
  }
}
