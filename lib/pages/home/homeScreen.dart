import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/DailyVerseCard.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:bhakti_bhoomi/widgets/common/section_label.dart';
import 'package:bhakti_bhoomi/widgets/common/text_medallion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  final String title;
  const Home({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('EEE, d MMMM').format(DateTime.now());
    return Scaffold(
      backgroundColor: AppColors.page,
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final firstName = state.userInfo?.firstName;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: [
                Text(date, style: AppTypography.textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(firstName != null ? 'नमस्ते, $firstName' : 'नमस्ते',
                    style: TextStyle(fontFamily: AppFonts.devanagari, fontSize: 30, color: AppColors.ink)),
                const SizedBox(height: 18),
                const DailyVerseCard(),
                const SizedBox(height: 16),
                _StreakCard(),
                const SizedBox(height: 22),
                const SectionLabel('PRACTICE · साधना'),
                const SizedBox(height: 12),
                _QuickActions(),
                const SizedBox(height: 22),
                const SectionLabel('CONTINUE'),
                const SizedBox(height: 12),
                AppCard(
                  onTap: () => context.goNamed(Routing.library.name),
                  child: Row(
                    children: [
                      const TextMedallion(glyph: 'गी'),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Explore the Library', style: AppTypography.textTheme.titleMedium),
                            Text('सभी ग्रंथ · all sacred texts',
                                style: TextStyle(fontFamily: AppFonts.devanagari, fontSize: 13, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textFaint),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  // Placeholder visual; wired to local streak tracking in Phase 4 (Your Journey).
  static const _litDays = 6;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$_litDays-day streak', style: AppTypography.textTheme.titleMedium),
                Text('दीप जलाए रखें · keep the lamp lit', style: AppTypography.textTheme.bodySmall),
              ],
            ),
          ),
          Row(
            children: [
              for (int i = 0; i < 7; i++)
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: i < _litDays ? AppColors.gold : AppColors.surfaceAlt),
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(Icons.local_fire_department_rounded, color: AppColors.gold, size: 22),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      (_QA(Icons.radio_button_checked, 'Japa', () => context.goNamed(Routing.practice.name))),
      (_QA(Icons.music_note_rounded, 'Aarti', () => context.pushNamed(Routing.aartiInfo.name))),
      (_QA(Icons.menu_book_rounded, 'Read', () => context.goNamed(Routing.library.name))),
      (_QA(Icons.self_improvement, 'Meditate', () => context.goNamed(Routing.practice.name))),
    ];
    return Row(
      children: [
        for (final a in actions)
          Expanded(
            child: GestureDetector(
              onTap: a.onTap,
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surfaceAlt),
                    ),
                    child: Icon(a.icon, color: AppColors.terracotta),
                  ),
                  const SizedBox(height: 8),
                  Text(a.label, style: AppTypography.textTheme.bodySmall),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _QA {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  _QA(this.icon, this.label, this.onTap);
}
