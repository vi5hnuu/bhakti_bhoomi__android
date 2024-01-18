class ChanakyaNeetiChapterInfoModel {
  final int chapterNo;
  final int versesCount;

  const ChanakyaNeetiChapterInfoModel({
    required this.chapterNo,
    required this.versesCount,
  });

  factory ChanakyaNeetiChapterInfoModel.fromJson(Map<String, dynamic> json) {
    return ChanakyaNeetiChapterInfoModel(
      chapterNo: json['chapterNo'],
      versesCount: json['versesCount'],
    );
  }
}
