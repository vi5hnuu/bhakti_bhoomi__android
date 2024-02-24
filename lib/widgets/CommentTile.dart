import 'package:bhakti_bhoomi/models/CommentModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final bool isLikeUnlikeLoading;
  final String? parentCommentUsername;
  final VoidCallback? onCommentReply;
  final VoidCallback? onCommentLike;
  final CancelToken _likeCancelToken = CancelToken();

  CommentTile({super.key, required this.comment, this.parentCommentUsername, this.isLikeUnlikeLoading = false, this.onCommentLike, this.onCommentReply});

  @override
  Widget build(BuildContext context) {
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
                IconButton(
                    onPressed: isLikeUnlikeLoading ? null : onCommentLike,
                    icon: isLikeUnlikeLoading
                        ? const SpinKitPumpingHeart(color: Colors.grey, size: 18)
                        : Icon(comment.likedByMe ? Icons.favorite : Icons.favorite_border, color: comment.likedByMe ? Colors.red : Colors.grey)),
                Text(comment.likeCount.toString())
              ])
            ],
          ),
        ],
      ),
    );
  }
}
