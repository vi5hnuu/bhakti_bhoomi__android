import 'package:bhakti_bhoomi/models/NewComment.dart';
import 'package:flutter/material.dart';

class CommentTileShimmer extends StatelessWidget {
  final NewComment newComment;
  final String? parentCommentUsername;

  const CommentTileShimmer({super.key, required this.newComment, this.parentCommentUsername});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const CircleAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(newComment.username),
                    RichText(
                        text: TextSpan(
                      text: parentCommentUsername != null ? "@${parentCommentUsername} " : "",
                      style: const TextStyle(color: Colors.blue),
                      children: [
                        TextSpan(text: "${newComment.content}", style: TextStyle(color: Colors.black)),
                      ],
                    )),
                    TextButton(
                        style: ButtonStyle(
                            minimumSize: WidgetStateProperty.all(Size.zero),
                            padding: WidgetStateProperty.all(const EdgeInsets.only(top: 9)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: WidgetStateProperty.all(Colors.grey),
                            splashFactory: NoSplash.splashFactory,
                            overlayColor: WidgetStateProperty.all(Colors.transparent)),
                        onPressed: null,
                        child: const Text("reply"))
                  ],
                ),
              ),
              Column(children: [
                IconButton(
                  onPressed: null,
                  icon: const Icon(Icons.favorite_outline),
                ),
                Text('0')
              ])
            ],
          ),
        ],
      ),
    );
  }
}
