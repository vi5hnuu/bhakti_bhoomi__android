class MantraInfoModel {
  final String id;
  final String title;
  final Map<String, String> description;

  const MantraInfoModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory MantraInfoModel.fromJson(Map<String, dynamic> json) {
    return MantraInfoModel(
      id: json['id'],
      title: json['title'],
      description: Map<String, String>.from((json['description'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as String))),
    );
  }
}
