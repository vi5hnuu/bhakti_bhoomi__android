class VratkathaModel {
    String id;
    String imagePath;
    String? title;
    Katha katha;

    VratkathaModel({
        required this.id,
        required this.imagePath,
        this.title,
        required this.katha
    });

    factory VratkathaModel.fromJson(Map<String, dynamic> json) {
        return VratkathaModel(
            id: json['id'],
            imagePath: json['imagePath'],
            title: json['title'] as String?,
            katha: Katha.fromJson(json['katha'])
        );
    }
}

class Katha{
    String? heading;
    List<KathaText> text;

    Katha({
        this.heading,
        required this.text
    });

    factory Katha.fromJson(Map<String, dynamic> json) {
        return Katha(
            heading: json['heading'] as String?,
            text: (json['text'] as List).map((e) => KathaText.fromJson(e)).toList()
        );
    }
}

class KathaText{
    String? title;
    List<String> description;

    KathaText({
        this.title,
        required this.description
    });

    factory KathaText.fromJson(Map<String, dynamic> json) {
        return KathaText(
            title: json['title'] as String?,
            description: (json['description'] as List).map((desc)=>desc as String).toList()
        );
    }
}