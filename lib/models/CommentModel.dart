class CommentModel {
  final String id;
  final String commentForId;
  final String username;
  final String userId;
  final String? parentCommentUserId;
  final String profileImageUrl;
  final String content;
  final int likeCount;
  final List<CommentModel> childComments; //in future if we want min x child comment to initially send with parent...
  final int totalChildComments;
  final String? parentCommentId;
  final DateTime createdAt;
  final bool likedByMe;

  CommentModel({
    required this.id,
    required this.commentForId,
    required this.username,
    required this.userId,
    this.parentCommentUserId,
    required this.profileImageUrl,
    required this.content,
    required this.likeCount,
    required this.childComments,
    required this.totalChildComments,
    this.parentCommentId,
    required this.createdAt,
    required this.likedByMe,
  });

  CommentModel copyWith({
    String? content,
    int? likeCount,
    int? totalChildComments,
    List<CommentModel>? childComments,
    bool? likedByMe,
  }) {
    return CommentModel(
      id: id,
      commentForId: commentForId,
      username: username,
      userId: userId,
      parentCommentUserId: parentCommentUserId,
      profileImageUrl: profileImageUrl,
      content: content ?? this.content,
      likeCount: likeCount ?? this.likeCount,
      childComments: childComments ?? this.childComments,
      totalChildComments: totalChildComments ?? this.totalChildComments,
      parentCommentId: parentCommentId,
      createdAt: createdAt,
      likedByMe: likedByMe ?? this.likedByMe,
    );
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      commentForId: json['comment_for_id'],
      username: json['username'],
      userId: json['user_id'],
      parentCommentUserId: json['parent_comment_user_id'],
      profileImageUrl: json['profile_image_url'],
      content: json['content'],
      likeCount: json['likeCount'],
      childComments: (json['child_comments'] as List).map((e) => CommentModel.fromJson(e)).toList(),
      totalChildComments: json['totalChildComments'],
      parentCommentId: json['parent_comment_id'],
      createdAt: DateTime.parse(json['created_at']),
      likedByMe: json['likedByMe'],
    );
  }
}
