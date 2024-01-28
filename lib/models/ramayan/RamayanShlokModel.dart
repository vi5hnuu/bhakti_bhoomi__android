class RamayanShlokModel {
  final String sargaId;
  final int sargaNo;
  final String language;
  final String kanda;
  final int shlokNo;
  final String shlok;
  final String translation;
  final String explaination;

  const RamayanShlokModel({
    required this.shlokNo,
    required this.shlok,
    required this.translation,
    required this.explaination,
    required this.language,
    required this.kanda,
    required this.sargaId,
    required this.sargaNo,
  });

  factory RamayanShlokModel.fromJson(Map<String, dynamic> json) {
    return RamayanShlokModel(
      shlokNo: json['shlokNo'],
      shlok: json['shlok'],
      translation: json['translation'],
      explaination: json['explaination'],
      language: json['language'],
      kanda: json['kanda'],
      sargaId: json['sargaId'],
      sargaNo: json['sargaNo'],
    );
  }
}
