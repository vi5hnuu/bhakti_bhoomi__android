import 'package:bhakti_bhoomi/models/bookmark/BookmarkModel.dart';
import 'package:bhakti_bhoomi/state/bookmark/bookmark_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.2)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(Icons.bookmark, color: Theme.of(context).primaryColor, size: 20),
        ),
        title: Text(bookmark.contentId, style: const TextStyle(fontSize: 13, fontFamily: 'NotoSansDevanagari')),
        subtitle: bookmark.addedAt != null
            ? Text(_formatDate(bookmark.addedAt!), style: const TextStyle(fontSize: 11, color: Colors.grey))
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          onPressed: () => context.read<BookmarkBloc>().add(RemoveBookmarkEvent(bookmarkId: bookmark.id)),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
