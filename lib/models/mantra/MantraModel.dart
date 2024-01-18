class MantraModel {
  final String title;
  final Map<String, String> description;
  final Map<String, List<String>> translations;
  final List<MantraModel>? subMantras;

  const MantraModel({required this.title, required this.description, required this.translations, this.subMantras});

  factory MantraModel.fromJson(Map<String, dynamic> json) {
    return MantraModel(
      title: json['title'],
      description: Map<String, String>.from(json['description'].map((key, value) => MapEntry<String, String>(key, value))),
      translations: Map<String, List<String>>.from(json['translations'].map((key, value) => MapEntry<String, List<String>>(key, List<String>.from(value)))),
      subMantras: json['subMantras'] != null ? List<MantraModel>.from(json['subMantras'].map((item) => MantraModel.fromJson(item))) : null,
    );
  }
}
