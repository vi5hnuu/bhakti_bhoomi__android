import 'package:bhakti_bhoomi/models/CommentModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final bool isLikeUnlikeLoading;
  final String? parentCommentUsername;
  final VoidCallback? onCommentReply;
  final VoidCallback? onCommentLike;

  CommentTile({super.key, required this.comment, this.parentCommentUsername, this.isLikeUnlikeLoading = false, this.onCommentLike, this.onCommentReply});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showMenu(context: context, position: RelativeRect.fromLTRB(0, 0, 0, 0), items: []);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(child: ClipOval(child: Image.network(comment.profileImageUrl))),
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
                      )),
                      TextButton(
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(Size.zero),
                              padding: MaterialStateProperty.all(const EdgeInsets.only(top: 9)),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: MaterialStateProperty.all(Colors.grey),
                              splashFactory: NoSplash.splashFactory,
                              overlayColor: MaterialStateProperty.all(Colors.transparent)),
                          onPressed: onCommentReply,
                          child: const Text("reply"))
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
      ),
    );
  }
}
