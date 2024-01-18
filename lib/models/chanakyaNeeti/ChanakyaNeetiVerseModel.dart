class ChanakyaNeetiVerseModel {
  final String id;
  final int chapterNo;
  final int verseNo;
  final Map<String, String> translations;

  const ChanakyaNeetiVerseModel({
    required this.id,
    required this.chapterNo,
    required this.verseNo,
    required this.translations,
  });

  factory ChanakyaNeetiVerseModel.fromJson(Map<String, dynamic> json) {
    return ChanakyaNeetiVerseModel(
      id: json['id'],
      chapterNo: json['chapterNo'],
      verseNo: json['verseNo'],
      translations: Map<String, String>.from(json['translations'].map((key, value) => MapEntry<String, String>(key, value))),
    );
  }
}
