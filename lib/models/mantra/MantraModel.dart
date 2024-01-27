class MantraModel {
  final String title;
  final Map<String, String> description;
  final Map<String, List<String>>? translations;
  final List<MantraModel>? subMantras;

  const MantraModel({required this.title, required this.description, this.translations, this.subMantras});

  factory MantraModel.fromJson(Map<String, dynamic> json) {
    return MantraModel(
      title: json['title'],
      description: Map<String, String>.from((json['description'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as String))),
      translations: json['translations'] != null
          ? Map<String, List<String>>.from((json['translations'] as Map<String, dynamic>).map((key, value) => MapEntry(key, (value as List).map((e) => e as String).toList())))
          : null,
      subMantras: json['subMantras'] != null ? (json['subMantras'] as List).map((e) => MantraModel.fromJson(e)).toList() : null,
    );
  }
}
