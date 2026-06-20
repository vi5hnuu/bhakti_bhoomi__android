import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../theme/app_colors.dart';

/// Standard centred loading indicator in the brand accent.
class AppLoader extends StatelessWidget {
  final double size;
  const AppLoader({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(color: AppColors.terracotta, size: size),
    );
  }
}

/// Empty-state placeholder with an icon and message.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final Widget? action;
  const EmptyState({super.key, required this.icon, required this.message, this.action});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.textFaint),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
}
