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
        translations: Map<String, Map<String, List<ChalisaVerseModel>>>.from(
          json['translations'].map((key, value) => MapEntry<String, Map<String, List<ChalisaVerseModel>>>(
              key,
              Map<String, List<ChalisaVerseModel>>.from(
                  value.map((key, value) => MapEntry<String, List<ChalisaVerseModel>>(key, List<ChalisaVerseModel>.from(value.map((item) => ChalisaVerseModel.fromJson(item)))))))),
        ));
  }
}
