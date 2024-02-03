import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  const CustomTextButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: this.onPressed,
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          disabledBackgroundColor: Colors.grey.withOpacity(0.2),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
          textStyle: const TextStyle(color: Colors.black)),
      child: this.child,
    );
  }
}
