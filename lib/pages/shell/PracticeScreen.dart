import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:flutter/material.dart';

/// Practice hub — entry point for Japa Mala, Aarti player, Meditate and
/// Panchang. The individual practices are wired in later phases; the cards
/// are present so the navigation structure matches the design.
class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final practices = [
      (_P(Icons.radio_button_checked, 'Japa Mala', 'जप · 108 count', AppColors.terracotta)),
      (_P(Icons.music_note_rounded, 'Aarti', 'आरती · sing along', AppColors.gold)),
      (_P(Icons.self_improvement, 'Meditate', 'ध्यान · quiet timer', AppColors.goldDeep)),
      (_P(Icons.calendar_month_rounded, 'Panchang', 'पंचांग · today', AppColors.textMuted)),
    ];
    return Scaffold(
      backgroundColor: AppColors.page,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text('Practice', style: AppTypography.textTheme.displayMedium),
            Text('नित्य साधना · daily sadhana',
                style: TextStyle(fontFamily: AppFonts.devanagari, fontSize: 14, color: AppColors.textMuted)),
            const SizedBox(height: 20),
            for (final p in practices) ...[
              AppCard(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${p.title} — coming together')),
                ),
                child: Row(
                  children: [
                    CircleAvatar(radius: 24, backgroundColor: p.tint.withValues(alpha: 0.15), child: Icon(p.icon, color: p.tint)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.title, style: AppTypography.textTheme.titleMedium),
                          Text(p.subtitle,
                              style: TextStyle(fontFamily: AppScript.familyFor(p.subtitle), fontSize: 13, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textFaint),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _P {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color tint;
  _P(this.icon, this.title, this.subtitle, this.tint);
}
