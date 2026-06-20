import 'package:bhakti_bhoomi/models/bookmark/BookmarkModel.dart';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/bookmark/bookmark_bloc.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/app_card.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/section_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  void initState() {
    context.read<BookmarkBloc>().add(const FetchBookmarksEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Bookmarks',
      subtitle: 'बुकमार्क',
      body: BlocBuilder<BookmarkBloc, BookmarkState>(
        builder: (context, state) {
          if (state.isLoading) return const AppLoader();
          if (state.bookmarks.isEmpty) {
            return const EmptyState(
              icon: Icons.bookmark_border_rounded,
              message: 'No bookmarks yet.\nSave verses while reading to find them here.',
            );
          }

          final Map<String, List<BookmarkModel>> grouped = {};
          for (final b in state.bookmarks) {
            grouped.putIfAbsent(b.contentType, () => []).add(b);
          }

          return RefreshIndicator(
            onRefresh: () async => context.read<BookmarkBloc>().add(const FetchBookmarksEvent()),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 18, 0, 10),
                      child: SectionLabel('${_label(entry.key)} · ${entry.value.length}'),
                    ),
                    ...entry.value.map((b) => _BookmarkTile(bookmark: b)),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  String _label(String contentType) {
    const map = {
      'bhagavad_geeta': 'Bhagavad Gita',
      'chanakya_neeti': 'Chanakya Neeti',
      'mahabharat': 'Mahabharat',
      'ramayan': 'Valmiki Ramayan',
      'ramcharitmanas': 'Ramcharitmanas',
      'rigveda': 'Rig Veda',
      'brahmasutra': 'Brahma Sutra',
      'yoga_sutra': 'Yoga Sutra',
      'guru_granth_sahib': 'Guru Granth Sahib',
      'chalisa': 'Chalisa',
      'aarti': 'Aarti',
    };
    return map[contentType] ?? contentType;
  }
}

class _BookmarkTile extends StatelessWidget {
  final BookmarkModel bookmark;

  const _BookmarkTile({required this.bookmark});

  @override
  Widget build(BuildContext context) {
    final description = _humanReadable(bookmark.contentType, bookmark.contentId);
    final canNavigate = _canNavigate(bookmark.contentType);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        onTap: canNavigate ? () => _navigate(context, bookmark) : null,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.bookmark_rounded, color: AppColors.gold, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(description, style: AppTypography.textTheme.titleSmall),
                  if (bookmark.addedAt != null) Text(_formatDate(bookmark.addedAt!), style: AppTypography.textTheme.bodySmall),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
              onPressed: () => context.read<BookmarkBloc>().add(RemoveBookmarkEvent(bookmarkId: bookmark.id)),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns a human-readable description for the bookmarked content.
  String _humanReadable(String contentType, String contentId) {
    try {
      switch (contentType) {
        case 'bhagavad_geeta':
          final parts = contentId.split('-');
          final chapter = parts[0].split('_')[1];
          final shlok = parts[1].replaceAll('shlokNo', '');
          return 'Chapter $chapter · Shlok $shlok';
        case 'chanakya_neeti':
          final parts = contentId.split('-');
          final chapter = parts[0].split('_')[1];
          final verse = parts[1].split('_')[1];
          return 'Chapter $chapter · Verse $verse';
        case 'mahabharat':
          final parts = contentId.split('-');
          final book = parts[0].split('_')[1];
          final chapter = parts[1].split('_')[1];
          final shlok = parts[2].split('_')[1];
          return 'Book $book · Chapter $chapter · Shlok $shlok';
        case 'ramayan':
          final kandaMatch = RegExp(r'kanda_(.+?)-sargaNo_(\d+)-shlokNo_(\d+)').firstMatch(contentId);
          if (kandaMatch != null) {
            return '${kandaMatch.group(1)} · Sarga ${kandaMatch.group(2)} · Shlok ${kandaMatch.group(3)}';
          }
          return contentId;
        case 'ramcharitmanas':
          final kandMatch = RegExp(r'kand_(.+?)-verseNo_(\d+)').firstMatch(contentId);
          if (kandMatch != null) {
            return '${kandMatch.group(1)} · Verse ${kandMatch.group(2)}';
          }
          return contentId;
        case 'rigveda':
          final parts = contentId.split('-');
          final mandala = parts[0].split('_')[1];
          final sukta = parts[1].split('_')[1];
          return 'Mandala $mandala · Sukta $sukta';
        case 'brahmasutra':
          final parts = contentId.split('-');
          final chapter = parts[0].split('_')[1];
          final quater = parts[1].split('_')[1];
          final sutra = parts[2].split('_')[1];
          return 'Chapter $chapter · Quater $quater · Sutra $sutra';
        case 'yoga_sutra':
          final parts = contentId.split('-');
          final chapter = parts[0].split('_')[1];
          final sutra = parts[1].split('_')[1];
          return 'Chapter $chapter · Sutra $sutra';
        case 'guru_granth_sahib':
          final parts = contentId.split('-');
          final raga = parts[0].split('_')[1];
          final part = parts[1].split('_')[1];
          return 'Raga $raga · Part $part';
        default:
          return contentId;
      }
    } catch (_) {
      return contentId;
    }
  }

  bool _canNavigate(String contentType) {
    const navigable = {
      'bhagavad_geeta', 'chanakya_neeti', 'mahabharat', 'ramayan',
      'ramcharitmanas', 'rigveda', 'brahmasutra', 'yoga_sutra', 'guru_granth_sahib',
    };
    return navigable.contains(contentType);
  }

  void _navigate(BuildContext context, BookmarkModel bookmark) {
    try {
      final contentId = bookmark.contentId;
      switch (bookmark.contentType) {
        case 'bhagavad_geeta':
          final chapterNo = contentId.split('-')[0].split('_')[1];
          GoRouter.of(context).pushNamed(Routing.bhagvadGeetaChapterShloks.name, pathParameters: {'chapterNo': chapterNo});
        case 'chanakya_neeti':
          final chapterNo = contentId.split('-')[0].split('_')[1];
          GoRouter.of(context).pushNamed(Routing.chanakyaNitiChapterShlok.name, pathParameters: {'chapterNo': chapterNo});
        case 'mahabharat':
          final parts = contentId.split('-');
          final bookNo = parts[0].split('_')[1];
          final chapterNo = parts[1].split('_')[1];
          GoRouter.of(context).pushNamed(Routing.mahabharatBookChapterShloks.name, pathParameters: {'bookNo': bookNo, 'chapterNo': chapterNo});
        case 'ramayan':
          final m = RegExp(r'kanda_(.+?)-sargaNo_(\d+)').firstMatch(contentId);
          if (m != null) {
            GoRouter.of(context).pushNamed(Routing.valmikiRamayanShlok.name, pathParameters: {'kand': m.group(1)!, 'sargaNo': m.group(2)!});
          }
        case 'ramcharitmanas':
          final m = RegExp(r'kand_(.+?)-verseNo').firstMatch(contentId);
          if (m != null) {
            GoRouter.of(context).pushNamed(Routing.ramcharitmanasKandVerses.name, pathParameters: {'kand': m.group(1)!});
          }
        case 'rigveda':
          final mandala = contentId.split('-')[0].split('_')[1];
          GoRouter.of(context).pushNamed(Routing.rigvedaMandalaSuktas.name, pathParameters: {'mandala': mandala});
        case 'brahmasutra':
          final parts = contentId.split('-');
          final chapterNo = parts[0].split('_')[1];
          final quaterNo = parts[1].split('_')[1];
          GoRouter.of(context).pushNamed(Routing.brahmasutra.name, pathParameters: {'chapterNo': chapterNo, 'quaterNo': quaterNo});
        case 'yoga_sutra':
          final chapterNo = contentId.split('-')[0].split('_')[1];
          GoRouter.of(context).pushNamed(Routing.yogaSutra.name, pathParameters: {'chapterNo': chapterNo});
        case 'guru_granth_sahib':
          final ragaNo = contentId.split('-')[0].split('_')[1];
          GoRouter.of(context).pushNamed(Routing.guruGranthSahibRagaParts.name, pathParameters: {'ragaNo': ragaNo});
      }
    } catch (_) {
      // contentId malformed — can't navigate
    }
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}
