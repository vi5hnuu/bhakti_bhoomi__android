class BhagvadGeetaChapterModel {
  final String id;
  final int chapterNumber;
  final int versesCount;
  final String name;
  final String translation;
  final String transliteration;
  final Map<String, String> meaning;
  final Map<String, String> summary;

  const BhagvadGeetaChapterModel({
    required this.id,
    required this.chapterNumber,
    required this.versesCount,
    required this.name,
    required this.translation,
    required this.transliteration,
    required this.meaning,
    required this.summary,
  });

  factory BhagvadGeetaChapterModel.fromJson(Map<String, dynamic> json) {
    return BhagvadGeetaChapterModel(
      id: json['id'],
      chapterNumber: json['chapterNumber'],
      versesCount: json['versesCount'],
      name: json['name'],
      translation: json['translation'],
      transliteration: json['transliteration'],
      meaning: json['meaning'],
      summary: json['summary'],
    );
  }
}
