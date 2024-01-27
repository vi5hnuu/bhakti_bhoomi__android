import 'package:bhakti_bhoomi/models/mantra/MantraModel.dart';

class MantraGroupModel {
  final String id;
  final String title;
  final Map<String, String> description;
  final List<MantraModel> mantras;

  const MantraGroupModel({required this.id, required this.title, required this.description, required this.mantras});

  factory MantraGroupModel.fromJson(Map<String, dynamic> json) {
    return MantraGroupModel(
      id: json['id'],
      title: json['title'],
      description: Map<String, String>.from((json['description'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as String))),
      mantras: (json['mantras'] as List).map((mantra) => MantraModel.fromJson(mantra)).toList(),
    );
  }
}
