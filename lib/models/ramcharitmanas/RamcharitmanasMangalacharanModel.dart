class RamcharitmanasMangalacharanModel {
  final String id;
  final String kanda;
  final String type;
  final String text;
  final String language;

  const RamcharitmanasMangalacharanModel({
    required this.id,
    required this.kanda,
    required this.type,
    required this.text,
    required this.language,
  });

  factory RamcharitmanasMangalacharanModel.fromJson(Map<String, dynamic> json) {
    return RamcharitmanasMangalacharanModel(
      id: json['id'],
      kanda: json['kanda'],
      type: json['type'],
      text: json['text'],
      language: json['language'],
    );
  }
}
