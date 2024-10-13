class MantraAudioInfoModel {
  final String id;
  final Map<String,String> title;

  const MantraAudioInfoModel({
    required this.id,
    required this.title,
  });

  factory MantraAudioInfoModel.fromJson(Map<String, dynamic> json) {
    return MantraAudioInfoModel(
      id: json['id'],
      title: Map<String, String>.from((json['title'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as String))),
    );
  }
}
