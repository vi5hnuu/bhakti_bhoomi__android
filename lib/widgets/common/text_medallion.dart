import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// A circular medallion holding a native-script abbreviation, used for catalog
/// rows (Library, continue-reading). Tradition tints the disc subtly.
class TextMedallion extends StatelessWidget {
  final String glyph;
  final double size;
  final bool sikh;
  const TextMedallion({super.key, required this.glyph, this.size = 52, this.sikh = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: sikh
              ? [const Color(0xFFB57A8C), const Color(0xFF8C5A6C)]
              : [AppColors.gold, AppColors.goldDeep],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        glyph,
        style: TextStyle(
          fontFamily: AppScript.familyFor(glyph),
          fontSize: size * 0.4,
          color: AppColors.onAccent,
          height: 1.0,
        ),
      ),
    );
  }
}
