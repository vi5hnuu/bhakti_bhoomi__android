class MantraAudioModel {
  final String id;
  final Map<String,String> title;
  final String audioUrl;
  final String thumbnail;

  const MantraAudioModel({
    required this.id,
    required this.title,
    required this.audioUrl,
    required this.thumbnail,
  });

  factory MantraAudioModel.fromJson(Map<String, dynamic> json) {
    return MantraAudioModel(
      id: json['id'],
      title: Map<String, String>.from((json['title'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as String))),
      audioUrl: json['audioUrl'],
      thumbnail: json['thumbnail'],
    );
  }
}
