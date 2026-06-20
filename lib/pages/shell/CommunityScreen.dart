import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:flutter/material.dart';

/// Sangha / Community feed. The social backend (posts/feed) is built in
/// Phase 6; until then this shows an on-brand placeholder so the tab exists.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sangha', style: AppTypography.textTheme.displayMedium),
                  Text('सत्संग · community',
                      style: TextStyle(fontFamily: AppFonts.devanagari, fontSize: 14, color: AppColors.textMuted)),
                ],
              ),
            ),
            const Expanded(
              child: EmptyState(
                icon: Icons.groups_rounded,
                message: 'Satsang is gathering.\nThe community feed arrives soon.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
