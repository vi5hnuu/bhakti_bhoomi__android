class ChalisaInfoModel {
  final String id;
  final String title;

  const ChalisaInfoModel({
    required this.id,
    required this.title,
  });

  factory ChalisaInfoModel.fromJson(Map<String, dynamic> json) {
    return ChalisaInfoModel(
      id: json['id'],
      title: json['title'],
    );
  }
}
