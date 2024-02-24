import 'package:bhakti_bhoomi/models/CommentModel.dart';
import 'package:bhakti_bhoomi/services/comment/CommentRepository.dart';
import 'package:bhakti_bhoomi/state/comment/comment_bloc.dart';
import 'package:bhakti_bhoomi/state/comment/comment_event.dart';
import 'package:bhakti_bhoomi/state/comment/comment_state.dart';
import 'package:bhakti_bhoomi/widgets/CommentTile.dart';
import 'package:bhakti_bhoomi/widgets/CustomInputField.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<dynamic> showCommentModelBottomSheet({required BuildContext context, required String commentForId}) {
  final Map<String, CancelToken> _likeCancelTokens = {};
  final bloc = CommentBloc(commentRepository: CommentRepository());
  bloc.add(GetCommentsEvent(commentForId: commentForId));

  return showModalBottomSheet(
      context: context,
      elevation: 5,
      isDismissible: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return BlocBuilder<CommentBloc, CommentState>(
            bloc: bloc,
            builder: (_, state) {
              return DraggableScrollableSheet(
                expand: false,
                snap: true,
                builder: (_, scrollController) {
                  return Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 78,
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
                          child: ListView(
                            shrinkWrap: true,
                            controller: scrollController,
                            children: [
                              const Icon(
                                Icons.horizontal_rule_rounded,
                                size: 48,
                              ),
                              const Text(
                                'Comments',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    itemBuilder: (_, index) {
                                      final comment = state.comments[index];
                                      return Column(
                                        children: [
                                          ..._getComments(comment: comment, bloc: bloc, commentForId: commentForId, cancelTokens: _likeCancelTokens),
                                          if (state.comments.isNotEmpty && state.hasMoreComments && state.comments.length - 1 == index)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 24.0, bottom: 12.0, top: 12.0),
                                              child: LoadMoreText(
                                                  title: 'read more comments',
                                                  onPress: () => _loadMoreComments(
                                                      commentForId: commentForId,
                                                      bloc: bloc,
                                                      pageNo: (state.comments.length / CommentState.defaultPageSize).ceil() + 1,
                                                      pageSize: CommentState.defaultPageSize)),
                                            )
                                        ],
                                      );
                                    },
                                    itemCount: state.comments.length),
                              ),
                              CustomInputField()
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            });
      }).whenComplete(() {
    _likeCancelTokens.forEach((key, value) {
      value.cancel("cancelling like");
    });
    bloc.close();
  });
}

void _likeComment({required String commentId, required bool like, required CommentBloc bloc, required Map<String, CancelToken> cancelTokens}) {
  cancelTokens[commentId]?.cancel("cancelled token");
  cancelTokens[commentId] = CancelToken();
  bloc.add(LikeUnlikeCommentEvent(id: commentId, like: like, cancelToken: cancelTokens[commentId]));
}

void _loadMoreComments({required String commentForId, String? parentCommentId, int? pageNo, int? pageSize, required CommentBloc bloc}) {
  bloc.add(GetCommentsEvent(commentForId: commentForId, parentCommentId: parentCommentId, pageNo: pageNo, pageSize: pageSize, cancelToken: null));
}

List<Widget> _getComments(
    {required CommentModel comment,
    CommentModel? parentComment,
    String? parentCommentUsername,
    required String commentForId,
    required CommentBloc bloc,
    required Map<String, CancelToken> cancelTokens}) {
  return [
    CommentTile(
        isLikeUnlikeLoading: (bloc.state.loadingFor.any((event) => (event is LikeUnlikeCommentEvent) && event.id == comment.id)),
        comment: comment,
        parentCommentUsername: parentCommentUsername,
        onCommentLike: () => _likeComment(commentId: comment.id, like: !comment.likedByMe, bloc: bloc, cancelTokens: cancelTokens)),
    Padding(
      padding: EdgeInsets.only(left: comment.parentCommentId == null ? 32.0 : 0),
      child: Column(children: [
        ...comment.childComments.map<Widget>((childComment) =>
            Column(children: _getComments(comment: childComment, parentComment: comment, parentCommentUsername: comment.username, commentForId: commentForId, bloc: bloc, cancelTokens: cancelTokens))),

        //load more child comments at same level
        if (comment.totalChildComments > comment.childComments.length)
          Padding(
            padding: EdgeInsets.only(left: parentComment != null ? 64.0 : 28.0, bottom: 12.0),
            child: LoadMoreText(
                title: 'read more replies',
                onPress: () => _loadMoreComments(
                    commentForId: commentForId,
                    bloc: bloc,
                    parentCommentId: comment.id,
                    pageNo: (comment.childComments.length / CommentState.defaultPageSize).ceil() + 1,
                    pageSize: CommentState.defaultPageSize)),
          )
      ]),
    ),
  ];
}

class LoadMoreText extends StatelessWidget {
  final VoidCallback? onPress;
  final String title;

  const LoadMoreText({super.key, this.onPress, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: 2,
          width: 48,
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: Colors.grey,
              ),
              onPressed: onPress,
              child: Text(
                title,
                style: const TextStyle(fontSize: 12.0),
              )),
        )
      ],
    );
  }
}
