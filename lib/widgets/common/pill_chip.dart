import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';

/// A selectable pill chip used for filters (e.g. All / Hindu / Sikh).
class PillChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const PillChip({super.key, required this.label, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.terracotta : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            border: Border.all(color: selected ? AppColors.terracotta : AppColors.surfaceAlt),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.onAccent : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
