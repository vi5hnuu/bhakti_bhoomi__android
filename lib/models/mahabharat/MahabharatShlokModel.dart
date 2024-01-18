class MahabharatShlokModel {
  final String id;
  final int book;
  final int chapter;
  final int shlokNo;
  final String text;

  const MahabharatShlokModel({
    required this.id,
    required this.book,
    required this.chapter,
    required this.shlokNo,
    required this.text,
  });

  factory MahabharatShlokModel.fromJson(Map<String, dynamic> json) {
    return MahabharatShlokModel(
      id: json['id'],
      book: json['book'],
      chapter: json['chapter'],
      shlokNo: json['shlokNo'],
      text: json['text'],
    );
  }
}
