class MahabharatBookInfoModel {
  final int bookNo;
  final Map<String, int> info; //chapterNo->total verses

  const MahabharatBookInfoModel({
    required this.bookNo,
    required this.info,
  });

  factory MahabharatBookInfoModel.fromJson(Map<String, dynamic> json) {
    return MahabharatBookInfoModel(
      bookNo: json['bookNo'],
      info: Map<String, int>.from(json['info'].map((key, value) => MapEntry<String, int>(key, value))),
    );
  }
}
