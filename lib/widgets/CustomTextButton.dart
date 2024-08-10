import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool? isLoading;
  final Widget child;
  const CustomTextButton({super.key, required this.onPressed, required this.child,this.isLoading});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: this.onPressed,
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          disabledBackgroundColor: Colors.grey.withOpacity(0.2),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
          textStyle: const TextStyle(color: Colors.black)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          this.child,
          if(isLoading==true) ...[const SizedBox(width: 10),SpinKitCircle(color: Theme.of(context).primaryColor,size: 20)],
        ],
      ),
    );
  }
}
