import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Font families bundled with the app (see `pubspec.yaml`).
class AppFonts {
  AppFonts._();

  /// Latin serif display — headings, titles.
  static const String display = 'Marcellus';

  /// Latin UI sans — body, labels, buttons.
  static const String sans = 'Mukta';

  /// Devanagari (Sanskrit / Hindi) — verses & scripture text.
  static const String devanagari = 'TiroDevanagariSanskrit';

  /// Gurmukhi — Guru Granth Sahib text.
  static const String gurmukhi = 'NotoSerifGurmukhi';
}

/// Helpers for picking the right font family based on the script of the content.
class AppScript {
  AppScript._();

  static final RegExp _devanagari = RegExp(r'[ऀ-ॿ]');
  static final RegExp _gurmukhi = RegExp(r'[਀-੿]');

  /// Returns the font family that best renders [text].
  /// Gurmukhi wins over Devanagari when both are present (GGS context).
  static String familyFor(String text) {
    if (_gurmukhi.hasMatch(text)) return AppFonts.gurmukhi;
    if (_devanagari.hasMatch(text)) return AppFonts.devanagari;
    return AppFonts.sans;
  }

  /// A serif/scripture style appropriate for [text], inheriting from [base].
  static TextStyle scriptureStyle(String text, {TextStyle? base}) {
    final family = familyFor(text);
    return (base ?? const TextStyle()).copyWith(
      fontFamily: family,
      height: 1.6,
    );
  }
}

/// The app-wide text theme built on the design fonts.
class AppTypography {
  AppTypography._();

  static const TextTheme textTheme = TextTheme(
    // Display / serif (Marcellus)
    displayLarge: TextStyle(fontFamily: AppFonts.display, fontSize: 40, color: AppColors.ink, height: 1.1),
    displayMedium: TextStyle(fontFamily: AppFonts.display, fontSize: 32, color: AppColors.ink, height: 1.15),
    displaySmall: TextStyle(fontFamily: AppFonts.display, fontSize: 26, color: AppColors.ink, height: 1.2),
    headlineMedium: TextStyle(fontFamily: AppFonts.display, fontSize: 22, color: AppColors.ink, height: 1.2),
    headlineSmall: TextStyle(fontFamily: AppFonts.display, fontSize: 18, color: AppColors.ink, height: 1.25),
    titleLarge: TextStyle(fontFamily: AppFonts.display, fontSize: 20, color: AppColors.ink),

    // UI sans (Mukta)
    titleMedium: TextStyle(fontFamily: AppFonts.sans, fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.ink),
    titleSmall: TextStyle(fontFamily: AppFonts.sans, fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink),
    bodyLarge: TextStyle(fontFamily: AppFonts.sans, fontSize: 16, color: AppColors.ink, height: 1.45),
    bodyMedium: TextStyle(fontFamily: AppFonts.sans, fontSize: 14, color: AppColors.textSecondary, height: 1.45),
    bodySmall: TextStyle(fontFamily: AppFonts.sans, fontSize: 12, color: AppColors.textMuted, height: 1.4),
    labelLarge: TextStyle(fontFamily: AppFonts.sans, fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink),
    labelMedium: TextStyle(fontFamily: AppFonts.sans, fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted),
    labelSmall: TextStyle(fontFamily: AppFonts.sans, fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textFaint, letterSpacing: 1.2),
  );

  /// Small uppercase gold section label, e.g. "VERSE OF THE DAY".
  static const TextStyle sectionLabel = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.goldDeep,
    letterSpacing: 2.0,
  );
}
