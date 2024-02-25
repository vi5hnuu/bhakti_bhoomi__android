import 'package:flutter/material.dart';

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
