class RigvedaVerseModel {
  final String id;
  final String veda;
  final int mandala;
  final int sukta;
  final String text;

  const RigvedaVerseModel({
    required this.id,
    required this.veda,
    required this.mandala,
    required this.sukta,
    required this.text,
  });

  factory RigvedaVerseModel.fromJson(Map<String, dynamic> json) {
    return RigvedaVerseModel(
      id: json['id'],
      veda: json['veda'],
      mandala: json['mandala'],
      sukta: json['sukta'],
      text: json['text'],
    );
  }
}
