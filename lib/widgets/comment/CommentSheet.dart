import 'package:bhakti_bhoomi/models/CommentModel.dart';
import 'package:bhakti_bhoomi/models/NewComment.dart';
import 'package:bhakti_bhoomi/models/UserInfo.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/state/comment/comment_bloc.dart';
import 'package:bhakti_bhoomi/state/comment/comment_event.dart';
import 'package:bhakti_bhoomi/state/comment/comment_state.dart';
import 'package:bhakti_bhoomi/widgets/comment/CommentSheetScrollHandle.dart';
import 'package:bhakti_bhoomi/widgets/comment/CommentTile.dart';
import 'package:bhakti_bhoomi/widgets/comment/CommentTileShimmer.dart';
import 'package:bhakti_bhoomi/widgets/comment/LoadMore.dart';
import 'package:bhakti_bhoomi/widgets/comment/NewCommentForm.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

class CommentSheet extends StatefulWidget {
  final String commentForId;
  const CommentSheet({super.key, required this.commentForId});

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final Map<String, CancelToken> _likeCancelTokens = {};
  CommentModel? replyToComment;
  final commentsListCntrl = ScrollController();
  late final UserInfo? userInfo;
  final tokenKey = 'new_comment';

  @override
  void initState() {
    userInfo = BlocProvider.of<AuthBloc>(context).state.userInfo;
    BlocProvider.of<CommentBloc>(context).add(GetCommentsEvent(commentForId: widget.commentForId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
        buildWhen: (previous, current) => previous != current,
        builder: (_, state) {
          final showMainLoader = state.comments.isEmpty && state.loadingFor.any((e) => e is GetCommentsEvent);

          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: DraggableScrollableSheet(
              expand: false,
              snap: true,
              maxChildSize: 1.0,
              minChildSize: 0.7,
              shouldCloseOnMinExtent: false,
              initialChildSize: 0.7,
              builder: (_, scrollController) {
                final newCommentProcessing = state.loadingFor.whereType<CreateCommentEvent>().firstOrNull;

                return Container(
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CommentSheetScrollHandle(scrollController: scrollController),
                      Expanded(
                        child: Column(
                          children: [
                            if (showMainLoader || userInfo == null)
                              const Padding(
                                padding: EdgeInsets.only(top: 12.0),
                                child: SpinKitThreeBounce(color: Colors.blue, size: 24),
                              ),
                            Expanded(
                              child: ListView.builder(
                                  controller: commentsListCntrl,
                                  itemBuilder: (_, index) {
                                    final comment = state.comments[index];
                                    return Column(
                                      children: [
                                        //shimmer for topmost comment
                                        if (index == 0 && newCommentProcessing != null && newCommentProcessing.newComment.parentCommentId == null)
                                          Shimmer.fromColors(
                                              baseColor: Colors.white, highlightColor: Theme.of(context).primaryColor, child: CommentTileShimmer(newComment: newCommentProcessing.newComment)),

                                        //comments at index
                                        ..._getComments(comment: comment),

                                        //show loadmore
                                        if (state.comments.isNotEmpty && state.hasMoreComments && state.comments.length - 1 == index)
                                          Padding(
                                            padding: const EdgeInsets.only(left: 24.0, bottom: 12.0, top: 12.0),
                                            child: state.loadingFor.any((event) => (event is GetCommentsEvent) && event.parentCommentId == null)
                                                ? const SpinKitThreeBounce(color: Colors.blue, size: 8)
                                                : LoadMoreText(
                                                    title: 'read more comments',
                                                    onPress: () => _loadMoreComments(
                                                        commentForId: widget.commentForId,
                                                        pageNo: (state.comments.length / CommentState.defaultPageSize).ceil() + 1,
                                                        pageSize: CommentState.defaultPageSize)),
                                          )
                                      ],
                                    );
                                  },
                                  itemCount: state.comments.length),
                            ),
                            NewCommentForm(
                              onRemoveReplyTo: () => setState(() => replyToComment = null),
                              onAddComment: (value) {
                                _addComment(
                                    newComment: NewComment(
                                        commentForId: widget.commentForId,
                                        content: value,
                                        profileImageUrl: userInfo!.profileMeta!.secure_url,
                                        userId: userInfo!.id,
                                        username: userInfo!.username,
                                        parentCommentId: replyToComment != null ? replyToComment!.id : null,
                                        parentCommentUserId: replyToComment != null ? replyToComment!.userId : null));
                              },
                              replyToComment: replyToComment,
                              userInfo: userInfo,
                              isEnabled: !state.loadingFor.any((e) => e is CreateCommentEvent),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  void _likeComment({required String commentId, required bool like}) {
    _likeCancelTokens[commentId]?.cancel("cancelled token");
    _likeCancelTokens[commentId] = CancelToken();
    BlocProvider.of<CommentBloc>(context).add(LikeUnlikeCommentEvent(id: commentId, like: like));
  }

  void _addComment({required NewComment newComment}) {
    _likeCancelTokens[tokenKey]?.cancel("cancelled token");
    _likeCancelTokens[tokenKey] = CancelToken();
    BlocProvider.of<CommentBloc>(context).add(CreateCommentEvent(newComment: newComment, cancelToken: _likeCancelTokens[tokenKey]));
    // commentsListCntrl.animateTo(
    //   commentsListCntrl.position.minScrollExtent,
    //   duration: const Duration(seconds: 1),
    //   curve: Curves.fastOutSlowIn,
    // );
  }

  void _loadMoreComments({required String commentForId, String? parentCommentId, int? pageNo, int? pageSize}) {
    BlocProvider.of<CommentBloc>(context).add(GetCommentsEvent(commentForId: commentForId, parentCommentId: parentCommentId, pageNo: pageNo, pageSize: pageSize, cancelToken: null));
  }

  List<Widget> _getComments({required CommentModel comment, CommentModel? parentComment, String? parentCommentUsername}) {
    final state = BlocProvider.of<CommentBloc>(context).state;
    bool isLikeLoading = state.loadingFor.any((event) => (event is LikeUnlikeCommentEvent) && event.id == comment.id);
    bool loadingMoreReplies = state.loadingFor.any((event) => (event is GetCommentsEvent) && event.parentCommentId == comment.id);
    final CreateCommentEvent? newCmntProcessing = state.loadingFor.whereType<CreateCommentEvent>().firstOrNull;

    return [
      CommentTile(
          onCommentReply: () => setState(() {
                replyToComment = comment;
                // if (!fieldFocusNode.hasFocus) fieldFocusNode.requestFocus();
              }),
          isLikeUnlikeLoading: isLikeLoading,
          comment: comment,
          parentCommentUsername: parentCommentUsername,
          onCommentLike: () => _likeComment(commentId: comment.id, like: !comment.likedByMe)),
      Padding(
        padding: EdgeInsets.only(left: comment.parentCommentId == null ? 32.0 : 0),
        child: Column(children: [
          //shimmer for child comment
          if (newCmntProcessing != null && newCmntProcessing.newComment.parentCommentId == comment.id)
            Shimmer.fromColors(child: CommentTileShimmer(newComment: newCmntProcessing.newComment), baseColor: Colors.white, highlightColor: Theme.of(context).primaryColor),
          //child comments
          ...comment.childComments.map<Widget>((childComment) => Column(children: _getComments(comment: childComment, parentComment: comment, parentCommentUsername: comment.username))),

          //load more child comments at same level
          if (comment.totalChildComments > comment.childComments.length)
            Padding(
              padding: loadingMoreReplies ? const EdgeInsets.only(bottom: 12.0) : EdgeInsets.only(left: parentComment != null ? 64.0 : 28.0, bottom: 12.0),
              child: loadingMoreReplies
                  ? const SpinKitThreeBounce(color: Colors.blue, size: 8)
                  : LoadMoreText(
                      title: 'read more replies',
                      onPress: () => _loadMoreComments(
                          commentForId: widget.commentForId,
                          parentCommentId: comment.id,
                          pageNo: (comment.childComments.length / CommentState.defaultPageSize).ceil() + 1,
                          pageSize: CommentState.defaultPageSize)),
            )
        ]),
      ),
    ];
  }

  @override
  void dispose() {
    _likeCancelTokens.forEach((key, token) => token.cancel("cancelling if any req pending"));
    super.dispose();
  }
}
