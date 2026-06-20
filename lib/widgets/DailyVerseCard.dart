import 'package:bhakti_bhoomi/models/bhagvadGeeta/BhagvadGeetaShlokModel.dart';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/services/apis/DailyVerseApi.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

/// Design #02 — "Verse of the Day": an ink card with a gold label, the verse
/// in its native script, an English gloss and Read/Share actions.
class DailyVerseCard extends StatefulWidget {
  const DailyVerseCard({super.key});

  @override
  State<DailyVerseCard> createState() => _DailyVerseCardState();
}

class _DailyVerseCardState extends State<DailyVerseCard> {
  late final Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    _future = DailyVerseApi().getDailyVerse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 150,
            decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(22)),
            child: const Center(child: SpinKitThreeBounce(color: AppColors.gold, size: 20)),
          );
        }
        if (!snapshot.hasData || snapshot.data?['success'] != true) {
          return const SizedBox.shrink();
        }

        final verse = BhagvadGeetaShlokModel.fromJson(snapshot.data!['verse']);
        final reference = snapshot.data!['reference'] as String;
        final englishTranslation = _pickEnglishTranslation(verse.translationsBy);

        void openReader() => GoRouter.of(context).pushNamed(
              Routing.bhagvadGeetaChapterShloks.name,
              pathParameters: {'chapterNo': '${verse.chapter}'},
            );

        return Container(
          decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(22)),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('VERSE OF THE DAY', style: AppTypography.sectionLabel.copyWith(color: AppColors.gold)),
                  const Spacer(),
                  Text(reference, style: const TextStyle(color: AppColors.textFaint, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                verse.shlok,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppScript.familyFor(verse.shlok),
                  color: AppColors.onAccent,
                  fontSize: 18,
                  height: 1.6,
                ),
              ),
              if (englishTranslation != null) ...[
                const SizedBox(height: 10),
                Text(
                  '"$englishTranslation"',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textFaint, fontSize: 13, fontStyle: FontStyle.italic, height: 1.5),
                ),
              ],
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: openReader,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: AppColors.ink,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      ),
                      child: const Text('Read & reflect', style: TextStyle(fontFamily: AppFonts.sans, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: AppColors.darkSurfaceRing,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        final shareText = '${verse.shlok}\n\n${englishTranslation ?? ''}\n\n— Bhagavad Gita, $reference\n\nRead on Bhakti Bhoomi'.trim();
                        Share.share(shareText);
                      },
                      child: const SizedBox(width: 46, height: 46, child: Icon(Icons.share_outlined, color: AppColors.gold, size: 20)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String? _pickEnglishTranslation(Map<String, Map<String, String>> translationsBy) {
    for (final authorTranslations in translationsBy.values) {
      final en = authorTranslations['en'];
      if (en != null && en.isNotEmpty) return en;
    }
    return null;
  }
}
