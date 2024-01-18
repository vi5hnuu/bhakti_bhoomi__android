class RamayanShlokModel {
  final int shlokNo;
  final String shlok;
  final String translation;
  final String explaination;
  final String shlokLang;
  final String kand;

  const RamayanShlokModel({
    required this.shlokNo,
    required this.shlok,
    required this.translation,
    required this.explaination,
    required this.shlokLang,
    required this.kand,
  });

  factory RamayanShlokModel.fromJson(Map<String, dynamic> json) {
    return RamayanShlokModel(
      shlokNo: json['shlokNo'],
      shlok: json['shlok'],
      translation: json['translation'],
      explaination: json['explaination'],
      shlokLang: json['shlokLang'],
      kand: json['kand'],
    );
  }
}
