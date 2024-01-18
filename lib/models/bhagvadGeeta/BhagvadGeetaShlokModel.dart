class BhagvadGeetaShlokModel {
  final String id;
  final String chapter_id;
  final int chapter;
  final int verse;
  final String shlok;
  final String transliteration;
  final Map<String, Map<String, String>> translationsBy;

  const BhagvadGeetaShlokModel(
      {required this.id, required this.chapter_id, required this.chapter, required this.verse, required this.shlok, required this.transliteration, required this.translationsBy});

  factory BhagvadGeetaShlokModel.fromJson(Map<String, dynamic> json) {
    return BhagvadGeetaShlokModel(
      id: json['id'],
      chapter_id: json['chapter_id'],
      chapter: json['chapter'],
      verse: json['verse'],
      shlok: json['shlok'],
      transliteration: json['transliteration'],
      translationsBy: json['translationsBy'],
    );
  }
}
