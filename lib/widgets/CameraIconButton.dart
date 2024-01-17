import 'package:flutter/material.dart';

class CameraIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  CameraIconButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.red,
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black.withOpacity(0.3))),
      icon: Icon(
        Icons.camera_alt_outlined,
        size: 25,
        color: Colors.white,
      ),
      highlightColor: Colors.white.withOpacity(0.3),
      onPressed: onPressed,
    );
  }
}
