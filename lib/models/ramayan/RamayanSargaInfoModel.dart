class RamayanSargaInfoModel {
  final String sargaId;
  final String kanda;
  final int sargaNo;
  final Map<String, int> totalShloks;

  const RamayanSargaInfoModel({
    required this.sargaId,
    required this.kanda,
    required this.sargaNo,
    required this.totalShloks,
  });

  factory RamayanSargaInfoModel.fromJson(Map<String, dynamic> json) {
    return RamayanSargaInfoModel(
      sargaId: json['sargaId'],
      kanda: json['kanda'],
      sargaNo: json['sargaNo'],
      totalShloks: Map<String, int>.from(json['totalShloks'].map((key, value) => MapEntry<String, int>(key, value))),
    );
  }
}
