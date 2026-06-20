import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// A compact translation-language selector used by the scripture readers
/// that offer multiple translation languages (Yoga Sutra, Brahma Sutra,
/// Ramcharitmanas, …). [languages] maps a display label to its value.
class LanguageDropdown extends StatelessWidget {
  final Map<String, String> languages;
  final String? value;
  final ValueChanged<String?> onChanged;

  const LanguageDropdown({super.key, required this.languages, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.surfaceAlt),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.expand_more_rounded, color: AppColors.textMuted, size: 18),
          borderRadius: BorderRadius.circular(16),
          style: AppTypography.textTheme.labelLarge,
          dropdownColor: AppColors.page,
          hint: Text('Language', style: AppTypography.textTheme.labelMedium),
          items: languages.entries
              .map((e) => DropdownMenuItem<String>(value: e.value, child: Text(e.key)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
