class RamcharitmanasVerseModel {
  final String id;
  final int versesNo;
  final String kanda;
  final String text;
  final String language;

  const RamcharitmanasVerseModel({
    required this.id,
    required this.versesNo,
    required this.kanda,
    required this.text,
    required this.language,
  });

  factory RamcharitmanasVerseModel.fromJson(Map<String, dynamic> json) {
    return RamcharitmanasVerseModel(
      id: json['id'],
      versesNo: json['versesNo'],
      kanda: json['kanda'],
      text: json['text'],
      language: json['language'],
    );
  }
}
