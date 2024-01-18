class ChalisaVerseModel {
  final String title;
  final List<String> verses;

  const ChalisaVerseModel({
    required this.title,
    required this.verses,
  });

  factory ChalisaVerseModel.fromJson(Map<String, dynamic> json) {
    return ChalisaVerseModel(
      title: json['title'],
      verses: json['verses'],
    );
  }
}
