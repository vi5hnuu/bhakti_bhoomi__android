class BookmarkModel {
  final String id;
  final String contentId;
  final String contentType;
  final DateTime? addedAt;

  const BookmarkModel({
    required this.id,
    required this.contentId,
    required this.contentType,
    this.addedAt,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json['id'] as String,
      contentId: json['contentId'] as String,
      contentType: json['contentType'] as String,
      addedAt: json['addedAt'] != null ? DateTime.tryParse(json['addedAt'].toString()) : null,
    );
  }
}
