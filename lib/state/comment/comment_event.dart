import 'package:bhakti_bhoomi/models/NewComment.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class CommentEvent {
  final CancelToken? cancelToken;
  const CommentEvent({this.cancelToken});
}

class LikeCommentEvent extends CommentEvent {
  final String id;
  const LikeCommentEvent({required this.id, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class UnlikeCommentEvent extends CommentEvent {
  final String id;
  const UnlikeCommentEvent({required this.id, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class GetCommentEvent extends CommentEvent {
  final String id;
  const GetCommentEvent({required this.id, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class CreateCommentEvent extends CommentEvent {
  final NewComment newComment;
  const CreateCommentEvent({required this.newComment, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class DeleteCommentEvent extends CommentEvent {
  final String id;
  const DeleteCommentEvent({required this.id, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class GetCommentsByUserIdEvent extends CommentEvent {
  final String userId;
  final int? pageNo;
  final int? pageSize;
  const GetCommentsByUserIdEvent({required this.userId, this.pageNo, this.pageSize, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class GetCommentsEvent extends CommentEvent {
  final String commentForId;
  final String? parentCommentId;
  final int? pageNo;
  final int? pageSize;
  const GetCommentsEvent({required this.commentForId, this.parentCommentId, this.pageNo, this.pageSize, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class ClearStateEvent extends CommentEvent {
  const ClearStateEvent();
}
