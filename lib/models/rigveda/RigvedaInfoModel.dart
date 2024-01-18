class RigvedaInfoModel {
  final String veda;
  final int totalMandala;
  final Map<String, int> mandalaInfo; //total verse in each mangala

  const RigvedaInfoModel({
    required this.veda,
    required this.totalMandala,
    required this.mandalaInfo,
  });

  factory RigvedaInfoModel.fromJson(Map<String, dynamic> json) {
    return RigvedaInfoModel(
      veda: json['veda'],
      totalMandala: json['totalMandala'],
      mandalaInfo: Map<String, int>.from(json['mandalaInfo'].map((key, value) => MapEntry<String, int>(key, value))),
    );
  }
}
