import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Practice hub — entry point for Japa Mala, Aarti, Your Journey, Deities and
/// Daily Rituals (all local features).
class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final practices = [
      _P(Icons.radio_button_checked, 'Japa Mala', 'जप · 108 count', AppColors.terracotta, () => context.pushNamed(Routing.japa.name)),
      _P(Icons.music_note_rounded, 'Aarti', 'आरती · sing along', AppColors.gold, () => context.pushNamed(Routing.aartiInfo.name)),
      _P(Icons.timeline_rounded, 'Your Journey', 'साधना · streak & stats', AppColors.goldDeep, () => context.pushNamed(Routing.journey.name)),
      _P(Icons.brightness_7_rounded, 'Deities', 'देवी–देवता', const Color(0xFFB57A8C), () => context.pushNamed(Routing.deities.name)),
      _P(Icons.notifications_active_rounded, 'Daily Rituals', 'नित्य कर्म · reminders', AppColors.textMuted, () => context.pushNamed(Routing.rituals.name)),
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
                onTap: p.onTap,
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
  final VoidCallback onTap;
  _P(this.icon, this.title, this.subtitle, this.tint, this.onTap);
}
