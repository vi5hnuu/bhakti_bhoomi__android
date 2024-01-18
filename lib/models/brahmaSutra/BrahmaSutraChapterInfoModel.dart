class BrahmaSutraChapterInfoModel {
  final int totalQuaters;
  final Map<String, int> totalSutras;

  const BrahmaSutraChapterInfoModel({
    required this.totalQuaters,
    required this.totalSutras,
  });

  factory BrahmaSutraChapterInfoModel.fromJson(Map<String, dynamic> json) {
    return BrahmaSutraChapterInfoModel(
      totalQuaters: json['totalQuaters'],
      totalSutras: Map<String, int>.from(json['totalSutras'].map((key, value) => MapEntry<String, int>(key, value))),
    );
  }
}
