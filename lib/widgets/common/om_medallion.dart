import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A glowing gold disc with the ॐ glyph — the app's signature motif
/// (splash, aarti player, practice).
class OmMedallion extends StatelessWidget {
  final double size;
  final bool glow;
  const OmMedallion({super.key, this.size = 120, this.glow = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [AppColors.gold, AppColors.goldDeep],
          stops: [0.55, 1.0],
        ),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.45),
                  blurRadius: size * 0.3,
                  spreadRadius: size * 0.04,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Container(
          width: size * 0.78,
          height: size * 0.78,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.darkSurface),
          child: Center(
            child: Text(
              'ॐ',
              style: TextStyle(
                fontFamily: 'TiroDevanagariSanskrit',
                fontSize: size * 0.42,
                color: AppColors.gold,
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
