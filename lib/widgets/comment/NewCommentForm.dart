import 'package:bhakti_bhoomi/models/CommentModel.dart';
import 'package:bhakti_bhoomi/models/UserInfo.dart';
import 'package:bhakti_bhoomi/singletons/LoggerSingleton.dart';
import 'package:flutter/material.dart';

class NewCommentForm extends StatefulWidget {
  final CommentModel? replyToComment;
  final UserInfo? userInfo;
  final bool isEnabled;
  final Function(String) onAddComment;
  final VoidCallback onRemoveReplyTo;

  const NewCommentForm({super.key, required this.replyToComment, required this.userInfo, this.isEnabled = true, required this.onRemoveReplyTo, required this.onAddComment});

  @override
  State<NewCommentForm> createState() => _NewCommentFormState();
}

class _NewCommentFormState extends State<NewCommentForm> {
  final TextEditingController commentTextCntrl = TextEditingController();
  final FocusNode fieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        if (widget.replyToComment != null)
          Container(
            color: Colors.grey.shade50,
            child: ListTile(
              tileColor: Colors.red,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              title: RichText(
                  text: TextSpan(
                      text: 'Replying to ', style: const TextStyle(color: Colors.grey), children: [TextSpan(text: '@${widget.replyToComment!.username}', style: const TextStyle(color: Colors.blue))])),
              trailing: IconButton(
                onPressed: widget.onRemoveReplyTo,
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(splashFactory: NoSplash.splashFactory, minimumSize: Size.zero, padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              ),
            ),
          ),
        ListTile(
          leading: CircleAvatar(child: widget.userInfo?.profileMeta?.secure_url != null ? Image.network(widget.userInfo!.profileMeta!.secure_url) : const Icon(Icons.favorite_outlined)),
          title: TextFormField(
            controller: commentTextCntrl,
            autocorrect: true,
            enabled: widget.isEnabled,
            onFieldSubmitted: (value) {
              LoggerSingleton().logger.i('value :${value}');
              if (value.isEmpty) return;
              widget.onAddComment(value);
              commentTextCntrl.clear();
            },
            scribbleEnabled: true,
            minLines: 1,
            maxLines: 3,
            canRequestFocus: true,
            keyboardType: TextInputType.text,
            focusNode: fieldFocusNode,
            decoration: InputDecoration(hintText: "Reply as ${widget.userInfo!.username}", border: InputBorder.none),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    commentTextCntrl.dispose();
    fieldFocusNode.dispose();
    super.dispose();
  }
}
