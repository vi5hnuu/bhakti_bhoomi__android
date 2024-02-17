import 'package:bhakti_bhoomi/models/CommentModel.dart';
import 'package:bhakti_bhoomi/services/comment/CommentRepository.dart';
import 'package:bhakti_bhoomi/state/comment/comment_bloc.dart';
import 'package:bhakti_bhoomi/state/comment/comment_event.dart';
import 'package:bhakti_bhoomi/state/comment/comment_state.dart';
import 'package:bhakti_bhoomi/widgets/CommentTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<dynamic> showCommentModelBottomSheet({required BuildContext context, required String commentForId}) {
  final bloc = CommentBloc(commentRepository: CommentRepository());
  bloc.add(GetCommentsEvent(commentForId: commentForId));

  return showModalBottomSheet(
      context: context,
      elevation: 5,
      isDismissible: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return BlocBuilder<CommentBloc, CommentState>(
            bloc: bloc,
            builder: (context, state) => DraggableScrollableSheet(
                  expand: false,
                  snap: true,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
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
                            child: ListView.builder(
                                itemBuilder: (context, index) {
                                  final comment = state.comments[index];
                                  return Column(
                                    children: _getComments(comment: comment),
                                  );
                                },
                                itemCount: state.comments.length),
                          ),
                        ],
                      ),
                    );
                  },
                ));
      }).whenComplete(() => bloc.close());
}

List<Widget> _getComments({required CommentModel comment, String? parentCommentUsername}) {
  return [
    CommentTile(comment: comment, parentCommentUsername: parentCommentUsername),
    Padding(
      padding: EdgeInsets.only(left: comment.parentCommentId == null ? 32.0 : 0),
      child: Column(
        children: comment.childComments.map((childComment) => Column(children: _getComments(comment: childComment, parentCommentUsername: comment.username))).toList(),
      ),
    ),
    if (comment.totalChildComments > comment.childComments.length)
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.only(left: 48, right: 5),
            height: 2,
            width: 48,
            color: Colors.grey,
          ),
          TextButton(onPressed: () => {}, child: Text('View ${comment.totalChildComments - comment.childComments.length} more replies'))
        ],
      )
  ];
}
