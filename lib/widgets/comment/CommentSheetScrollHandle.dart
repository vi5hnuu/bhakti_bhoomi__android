import 'package:flutter/material.dart';

class CommentSheetScrollHandle extends StatelessWidget {
  final ScrollController scrollController;
  const CommentSheetScrollHandle({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
      child: ListView(
        controller: scrollController,
        shrinkWrap: true,
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
    );
  }
}
