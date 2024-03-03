import 'package:flutter/material.dart';

class EngageActions extends StatelessWidget {
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onBookmark;
  final bool isLiked;
  final bool isBookmarked;

  const EngageActions({
    super.key,
    required this.onLike,
    required this.onComment,
    required this.onBookmark,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            IconButton(
                style: IconButton.styleFrom(elevation: 7),
                onPressed: onLike,
                tooltip: 'Like',
                selectedIcon: const Icon(Icons.favorite, size: 36),
                isSelected: isLiked,
                icon: const Icon(Icons.favorite_border, size: 36)),
            const SizedBox(height: 10),
            IconButton(style: IconButton.styleFrom(elevation: 7), onPressed: onComment, icon: const Icon(Icons.mode_comment_outlined, size: 36)),
            const SizedBox(height: 10),
            IconButton(
              style: IconButton.styleFrom(elevation: 7),
              onPressed: onBookmark,
              icon: const Icon(Icons.bookmark_border, size: 38),
              tooltip: 'bookmark',
              selectedIcon: const Icon(Icons.bookmark_added_sharp, size: 38),
              isSelected: isBookmarked,
            ),
          ],
        ),
      ),
    );
  }
}
