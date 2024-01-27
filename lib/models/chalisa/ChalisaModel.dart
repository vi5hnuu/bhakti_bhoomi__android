import 'package:bhakti_bhoomi/models/chalisa/ChalisaVerseModel.dart';

class ChalisaModel {
  final String id;
  final String title;
  final Map<String, Map<String, List<ChalisaVerseModel>>> translations;

  const ChalisaModel({
    required this.id,
    required this.title,
    required this.translations,
  });

  factory ChalisaModel.fromJson(Map<String, dynamic> json) {
    return ChalisaModel(
        id: json['id'],
        title: json['title'],
        translations: Map.fromEntries((json['translations'] as Map<String, dynamic>).entries.map((e) =>
            MapEntry(e.key, Map.fromEntries((e.value as Map<String, dynamic>).entries.map((e1) => MapEntry(e1.key, (e1.value as List).map((e2) => ChalisaVerseModel.fromJson(e2)).toList())))))));
  }
}
