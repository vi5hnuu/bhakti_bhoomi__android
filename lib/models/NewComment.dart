class NewComment {
  final String commentForId;
  final String username;
  final String userId;
  final String? parentCommentUserId;
  final String profileImageUrl;
  final String content;
  final String? parentCommentId;

  Map<String, String?> toJson() {
    return {
      'commentForId': this.commentForId,
      'username': this.username,
      'userId': this.userId,
      'parentCommentUserId': this.parentCommentUserId,
      'profileImageUrl': this.profileImageUrl,
      'content': this.content,
      'parentCommentId': this.parentCommentId
    };
  }

  const NewComment({required this.commentForId, required this.username, required this.userId, this.parentCommentUserId, required this.profileImageUrl, required this.content, this.parentCommentId});
}
