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
      translationLanguages: Map<String, String>.from(json['translationLanguages'].map((key, value) => MapEntry<String, String>(key, value))),
      totalChapters: json['totalChapters'],
      chaptersInfo:
          Map<String, BrahmaSutraChapterInfoModel>.from(json['chaptersInfo'].map((key, value) => MapEntry<String, BrahmaSutraChapterInfoModel>(key, BrahmaSutraChapterInfoModel.fromJson(value)))),
    );
  }
}
