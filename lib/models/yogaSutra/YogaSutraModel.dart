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
      sutra: Map.fromEntries((json['sutra'] as Map<String, dynamic>).entries.map((e) => MapEntry<String, String>(e.key, e.value as String))),
      language: json['language'],
    );
  }
}
