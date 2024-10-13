import 'dart:ffi';

import 'package:bhakti_bhoomi/models/mantra/MantraAudioInfoModel.dart';

class MantraAudioPageModel {
  final List<MantraAudioInfoModel> data;
  final int total;

  const MantraAudioPageModel({
    required this.data,
    required this.total
  });

  factory MantraAudioPageModel.fromJson(Map<String, dynamic> json) {
    return MantraAudioPageModel(
      total: json['total'] as int,
      data: (json['data'] as List).map((audioInfo)=>MantraAudioInfoModel.fromJson(audioInfo)).toList(growable: false)
    );
  }
}
