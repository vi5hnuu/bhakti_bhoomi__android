import 'package:flutter/material.dart';

class CameraIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const CameraIconButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.red,
      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.black.withOpacity(0.3))),
      icon: const Icon(
        Icons.camera_alt_outlined,
        size: 25,
        color: Colors.white,
      ),
      highlightColor: Colors.white.withOpacity(0.3),
      onPressed: onPressed,
    );
  }
}
