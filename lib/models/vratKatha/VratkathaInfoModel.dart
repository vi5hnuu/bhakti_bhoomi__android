class VratkathaInfoModel {
   String id;
   String title;
   String imagePath;

   VratkathaInfoModel({
      required this.id,
      required this.title,
      required this.imagePath});

    factory VratkathaInfoModel.fromJson(Map<String, dynamic> json) {
      return VratkathaInfoModel(
        id: json['id'],
        title: json['title'],
        imagePath: json['imagePath']
      );
    }
}