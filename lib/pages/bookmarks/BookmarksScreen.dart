import 'package:bhakti_bhoomi/models/bookmark/BookmarkModel.dart';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/bookmark/bookmark_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bookmarks',
          style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<BookmarkBloc, BookmarkState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor));
          }
          if (state.bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bookmark_border, size: 72, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('No bookmarks yet', style: TextStyle(fontSize: 16, color: Colors.grey.shade500)),
                  const SizedBox(height: 8),
                  Text('Save verses while reading to find them here.', style: TextStyle(fontSize: 13, color: Colors.grey.shade400), textAlign: TextAlign.center),
                ],
              ),
            );
          }

          // Group by contentType
          final Map<String, List<BookmarkModel>> grouped = {};
          for (final b in state.bookmarks) {
            grouped.putIfAbsent(b.contentType, () => []).add(b);
          }

          return RefreshIndicator(
            onRefresh: () async => context.read<BookmarkBloc>().add(const FetchBookmarksEvent()),
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: grouped.entries.map((entry) {
                final label = _label(entry.key);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Icon(Icons.auto_stories, size: 18, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).primaryColor)),
                          const SizedBox(width: 8),
                          Text('(${entry.value.length})', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ),
                    ...entry.value.map((b) => _BookmarkTile(bookmark: b)),
                    const Divider(),
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.2)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: canNavigate ? () => _navigate(context, bookmark) : null,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(Icons.bookmark, color: Theme.of(context).primaryColor, size: 20),
        ),
        title: Text(description, style: const TextStyle(fontSize: 14)),
        subtitle: bookmark.addedAt != null
            ? Text(_formatDate(bookmark.addedAt!), style: const TextStyle(fontSize: 11, color: Colors.grey))
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canNavigate)
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
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
          // format: chapterNo_X-shlokNoY  (no underscore before shlok number)
          final parts = contentId.split('-');
          final chapter = parts[0].split('_')[1];
          final shlok = parts[1].replaceAll('shlokNo', '');
          return 'Chapter $chapter · Shlok $shlok';
        case 'chanakya_neeti':
          // format: chapterNo_X-verseNo_Y
          final parts = contentId.split('-');
          final chapter = parts[0].split('_')[1];
          final verse = parts[1].split('_')[1];
          return 'Chapter $chapter · Verse $verse';
        case 'mahabharat':
          // format: bookNo_X-chapterNo_Y-shlokNo_Z
          final parts = contentId.split('-');
          final book = parts[0].split('_')[1];
          final chapter = parts[1].split('_')[1];
          final shlok = parts[2].split('_')[1];
          return 'Book $book · Chapter $chapter · Shlok $shlok';
        case 'ramayan':
          // format: kanda_X-sargaNo_Y-shlokNo_Z-lang_W  (kanda may have spaces)
          final kandaMatch = RegExp(r'kanda_(.+?)-sargaNo_(\d+)-shlokNo_(\d+)').firstMatch(contentId);
          if (kandaMatch != null) {
            return '${kandaMatch.group(1)} · Sarga ${kandaMatch.group(2)} · Shlok ${kandaMatch.group(3)}';
          }
          return contentId;
        case 'ramcharitmanas':
          // format: kand_X-verseNo_Y-lang_W  (kand may have spaces)
          final kandMatch = RegExp(r'kand_(.+?)-verseNo_(\d+)').firstMatch(contentId);
          if (kandMatch != null) {
            return '${kandMatch.group(1)} · Verse ${kandMatch.group(2)}';
          }
          return contentId;
        case 'rigveda':
          // format: mandalaNo_X-suktaNo_Y
          final parts = contentId.split('-');
          final mandala = parts[0].split('_')[1];
          final sukta = parts[1].split('_')[1];
          return 'Mandala $mandala · Sukta $sukta';
        case 'brahmasutra':
          // format: chapterNo_X-quaterNo_Y-sutraNo_Z-lang_W
          final parts = contentId.split('-');
          final chapter = parts[0].split('_')[1];
          final quater = parts[1].split('_')[1];
          final sutra = parts[2].split('_')[1];
          return 'Chapter $chapter · Quater $quater · Sutra $sutra';
        case 'yoga_sutra':
          // format: chapterNo_X-sutraNo_Y-lang_W
          final parts = contentId.split('-');
          final chapter = parts[0].split('_')[1];
          final sutra = parts[1].split('_')[1];
          return 'Chapter $chapter · Sutra $sutra';
        case 'guru_granth_sahib':
          // format: raga_X-part_Y
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
