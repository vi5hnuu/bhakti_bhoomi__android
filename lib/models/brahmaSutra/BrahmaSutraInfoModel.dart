import 'package:bhakti_bhoomi/models/brahmaSutra/BrahmaSutraChapterInfoModel.dart';

class BrahmasutraInfoModel {
  final Map<String, String> translationLanguages;
  final int totalChapters;
  final Map<String, BrahmaSutraChapterInfoModel> chaptersInfo;

  const BrahmasutraInfoModel({
    required this.translationLanguages,
    required this.totalChapters,
    required this.chaptersInfo,
  });

  factory BrahmasutraInfoModel.fromJson(Map<String, dynamic> json) {
    return BrahmasutraInfoModel(
      translationLanguages: Map<String, String>.fromEntries((json['translationLanguages'] as Map<String, dynamic>).entries.map((e) => MapEntry(e.key, e.value as String))),
      totalChapters: json['totalChapters'],
      chaptersInfo:
          Map<String, BrahmaSutraChapterInfoModel>.fromEntries((json['chaptersInfo'] as Map<String, dynamic>).entries.map((e) => MapEntry(e.key, BrahmaSutraChapterInfoModel.fromJson(e.value)))),
    );
  }
}
