import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'common/primary_button.dart';

/// Error + retry view, restyled for the redesign. API is unchanged so existing
/// screens keep working: `RetryAgain(onRetry:..., error:...)`.
class RetryAgain extends StatelessWidget {
  final Function()? onRetry;
  final String error;

  const RetryAgain({super.key, required this.onRetry, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, color: AppColors.textFaint, size: 48),
            const SizedBox(height: 12),
            Text(
              error.isEmpty ? 'Something went wrong' : error,
              textAlign: TextAlign.center,
              style: AppTypography.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            if (onRetry != null)
              PrimaryButton(
                label: 'Try again',
                icon: Icons.refresh,
                expand: false,
                onPressed: onRetry,
              ),
          ],
        ),
      ),
    );
  }
}
