import 'package:bhakti_bhoomi/services/practice/practice_store.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/section_label.dart';
import 'package:flutter/material.dart';

/// Design #08 — Your Journey: local practice stats (streak, japa rounds &
/// beads, meditation minutes) sourced from [PracticeStore].
class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  int streak = 0, rounds = 0, beads = 0, minutes = 0;

  @override
  void initState() {
    _load();
    super.initState();
  }

  Future<void> _load() async {
    final store = PracticeStore.instance;
    final s = await store.streak();
    final r = await store.totalRounds();
    final b = await store.totalBeads();
    final m = await store.meditateMinutes();
    if (mounted) setState(() {
      streak = s;
      rounds = r;
      beads = b;
      minutes = m;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Your Journey',
      subtitle: 'आपकी साधना · the path so far',
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            AppCard(
              color: AppColors.darkSurface,
              borderColor: AppColors.darkSurface,
              padding: const EdgeInsets.all(22),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department_rounded, color: AppColors.gold, size: 44),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$streak-day streak', style: AppTypography.textTheme.headlineMedium!.copyWith(color: AppColors.onAccent)),
                      Text('दीप जलाए रखें · keep the lamp lit', style: TextStyle(fontFamily: AppFonts.devanagari, fontSize: 13, color: AppColors.textFaint)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const SectionLabel('PRACTICE · आँकड़े'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _statCard('$rounds', 'Japa rounds', Icons.radio_button_checked)),
                const SizedBox(width: 12),
                Expanded(child: _statCard('$beads', 'Total beads', Icons.blur_circular_rounded)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _statCard('$minutes', 'Meditation min', Icons.self_improvement)),
                const SizedBox(width: 12),
                Expanded(child: _statCard('${rounds * 108 + beads}', 'Lifetime japa', Icons.auto_awesome)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.terracotta, size: 22),
          const SizedBox(height: 10),
          Text(value, style: AppTypography.textTheme.displaySmall),
          Text(label, style: AppTypography.textTheme.bodySmall),
        ],
      ),
    );
  }
}
