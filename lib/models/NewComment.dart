class NewComment {
  final String commentForId;
  final String username;
  final String userId;
  final String? parentCommentUserId;
  final String profileImageUrl;
  final String content;
  final String? parentCommentId;

  const NewComment({required this.commentForId, required this.username, required this.userId, this.parentCommentUserId, required this.profileImageUrl, required this.content, this.parentCommentId});
}
