import 'package:bhakti_bhoomi/models/CommentModel.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final String? parentCommentUsername;
  final VoidCallback? onCommentLike;
  final VoidCallback? onCommentReply;
  final VoidCallback? onLoadMoreComments;
  const CommentTile({super.key, required this.comment, this.parentCommentUsername, this.onCommentLike, this.onCommentReply, this.onLoadMoreComments});

  @override
  Widget build(BuildContext context) {
    bool didILiked = BlocProvider.of<AuthBloc>(context).state.userInfo!.username == comment.username;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(child: Image.network(comment.profileImageUrl)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.username),
                    RichText(
                        text: TextSpan(
                      text: parentCommentUsername != null ? "@${parentCommentUsername} " : "",
                      style: TextStyle(color: Colors.blue),
                      children: [
                        TextSpan(text: "${comment.content}", style: TextStyle(color: Colors.black)),
                      ],
                    ))
                  ],
                ),
              ),
              Column(children: [
                IconButton(onPressed: this.onCommentLike, icon: Icon(didILiked ? Icons.favorite : Icons.favorite_border, color: didILiked ? Colors.red : Colors.grey)),
                Text(comment.likeCount.toString())
              ])
            ],
          ),
        ],
      ),
    );
  }
}
