import 'package:flutter/material.dart';
import '../../theme/app_typography.dart';

/// Small caption label shown above a form field in the auth/profile forms.
class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6, left: 2),
        child: Text(text, style: AppTypography.textTheme.labelMedium),
      );
}
