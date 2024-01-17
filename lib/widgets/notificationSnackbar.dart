import 'package:flutter/material.dart';

SnackBar notificationSnackbar({required String text, MaterialColor color = Colors.red, bool showCloseIcon = true}) {
  return SnackBar(
    content: Text(text),
    elevation: 5,
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    showCloseIcon: showCloseIcon,
    duration: const Duration(seconds: 2),
  );
}
