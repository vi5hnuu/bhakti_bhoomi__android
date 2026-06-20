import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// A row of single-digit OTP boxes, styled per the redesign. The parent owns
/// the [controllers] and [focusNodes] (length [length]) so submit logic is
/// unchanged.
class OtpInput extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final int length;
  final ValueChanged<String>? onCompleted;

  const OtpInput({
    super.key,
    required this.controllers,
    required this.focusNodes,
    this.length = 6,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(length, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == length - 1 ? 0 : 8),
            child: AspectRatio(
              aspectRatio: 0.86,
              child: TextField(
                controller: controllers[i],
                focusNode: focusNodes[i],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: AppTypography.textTheme.headlineMedium,
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.surfaceAlt),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.terracotta, width: 1.5),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && i < length - 1) {
                    focusNodes[i + 1].requestFocus();
                  } else if (value.isEmpty && i > 0) {
                    focusNodes[i - 1].requestFocus();
                  }
                  final code = controllers.map((c) => c.text).join();
                  if (code.length == length && !code.contains('')) onCompleted?.call(code);
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
