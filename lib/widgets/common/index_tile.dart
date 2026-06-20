import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'app_card.dart';

/// A numbered list row used by chapter / book / kand / mandala index screens:
/// a circled number, a title (with optional native + meta subtitles) and a
/// chevron.
class IndexTile extends StatelessWidget {
  final String number;
  final String title;
  final String? subtitle;
  final String? meta;
  final VoidCallback onTap;

  const IndexTile({
    super.key,
    required this.number,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.meta,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceAlt,
                border: Border.all(color: AppColors.border),
              ),
              alignment: Alignment.center,
              child: Text(number, style: AppTypography.textTheme.titleSmall),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Text(subtitle!,
                        style: TextStyle(fontFamily: AppScript.familyFor(subtitle!), fontSize: 13, color: AppColors.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  if (meta != null && meta!.isNotEmpty) Text(meta!, style: AppTypography.textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textFaint),
          ],
        ),
      ),
    );
  }
}
