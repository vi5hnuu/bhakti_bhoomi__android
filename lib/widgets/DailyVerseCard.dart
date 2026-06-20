import 'package:bhakti_bhoomi/models/bhagvadGeeta/BhagvadGeetaShlokModel.dart';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/services/apis/DailyVerseApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

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
    final primaryColor = Theme.of(context).primaryColor;
    return FutureBuilder<Map<String, dynamic>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            height: 120,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryColor.withOpacity(0.15)),
            ),
            child: Center(child: SpinKitThreeBounce(color: primaryColor, size: 20)),
          );
        }
        if (!snapshot.hasData || snapshot.data?['success'] != true) {
          return const SizedBox.shrink();
        }

        final verse = BhagvadGeetaShlokModel.fromJson(snapshot.data!['verse']);
        final reference = snapshot.data!['reference'] as String;
        final englishTranslation = _pickEnglishTranslation(verse.translationsBy);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [primaryColor.withOpacity(0.85), primaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => GoRouter.of(context).pushNamed(
                Routing.bhagvadGeetaChapterShloks.name,
                pathParameters: {'chapterNo': '${verse.chapter}'},
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Colors.white70, size: 16),
                        const SizedBox(width: 6),
                        const Text(
                          "Verse of the Day",
                          style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.2),
                        ),
                        const Spacer(),
                        Text(
                          reference,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      verse.shlok,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'NotoSansDevanagari',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    if (englishTranslation != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        englishTranslation,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            final shareText = '${verse.shlok}\n\n${englishTranslation ?? ''}\n\n— Bhagavad Gita, $reference\n\nRead on Bhakti Bhoomi'.trim();
                            Share.share(shareText);
                          },
                          icon: const Icon(Icons.share_outlined, color: Colors.white70, size: 16),
                          label: const Text('Share', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => GoRouter.of(context).pushNamed(
                            Routing.bhagvadGeetaChapterShloks.name,
                            pathParameters: {'chapterNo': '${verse.chapter}'},
                          ),
                          icon: const Icon(Icons.menu_book_outlined, color: Colors.white70, size: 16),
                          label: const Text('Read', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Picks the first available English translation from any author.
  String? _pickEnglishTranslation(Map<String, Map<String, String>> translationsBy) {
    for (final authorTranslations in translationsBy.values) {
      final en = authorTranslations['en'];
      if (en != null && en.isNotEmpty) return en;
    }
    return null;
  }
}
