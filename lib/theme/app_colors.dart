import 'package:flutter/material.dart';

/// Design tokens for the Bhakti Bhoomi redesign.
///
/// Extracted from the approved design comp (`Bhakti Bhoomi Redesign`).
/// A calm cream / gold / terracotta palette with a warm ink for text.
class AppColors {
  AppColors._();

  // Surfaces
  static const Color page = Color(0xFFFFFDF8); // lightest cream — page background
  static const Color surface = Color(0xFFF6EFE0); // card / raised surface
  static const Color surfaceAlt = Color(0xFFECE4D3); // sand — subtle fill / borders
  static const Color border = Color(0xFFC2B6A2); // muted border / disabled

  // Ink / text
  static const Color ink = Color(0xFF2C2722); // primary text, dark practice surface
  static const Color textSecondary = Color(0xFF5F584C);
  static const Color textMuted = Color(0xFF7C6F5A);
  static const Color textFaint = Color(0xFFA89E8C);

  // Accents
  static const Color terracotta = Color(0xFFB0673F); // primary accent / buttons
  static const Color gold = Color(0xFFCF9F4D); // highlights, progress, streak flame
  static const Color goldDeep = Color(0xFF9A7B3F); // section labels (e.g. "VERSE OF THE DAY")

  // Dark practice surface (Japa screen, etc.)
  static const Color darkSurface = Color(0xFF2C2722);
  static const Color darkSurfaceRing = Color(0xFF4A4136);

  // Misc
  static const Color onAccent = Color(0xFFFFFDF8);
  static const Color success = Color(0xFF4F7A4A);
  static const Color error = Color(0xFFB0473F);

  /// A soft translucent overlay used behind sheets / scrims.
  static Color scrim = ink.withValues(alpha: 0.45);
}
