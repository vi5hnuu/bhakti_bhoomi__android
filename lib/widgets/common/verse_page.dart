import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/state/bookmark/bookmark_bloc.dart';
import 'package:bhakti_bhoomi/state/like/like_bloc.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/utils/auth_guard.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

/// A single scripture verse page: a centred, script-aware verse plus the
/// shared engage actions (bookmark / like / comment / share). Used by every
/// verse reader so the look and the bookmark/like/comment wiring stay uniform.
class VersePage extends StatelessWidget {
  final String verseLabel;
  final String text;
  final double fontSize;
  final String contentId;
  final String shareText;
  final String contentType;

  /// Optional secondary text (e.g. translation / transliteration) shown under
  /// the main verse in a muted style.
  final String? secondary;

  /// Optional widget shown above the verse (e.g. a translation-language
  /// selector).
  final Widget? header;

  const VersePage({
    super.key,
    required this.verseLabel,
    required this.text,
    required this.fontSize,
    required this.contentId,
    required this.shareText,
    required this.contentType,
    this.secondary,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (header != null) ...[header!, const SizedBox(height: 18)],
                    if (verseLabel.isNotEmpty) ...[
                      Text(verseLabel, style: AppTypography.sectionLabel),
                      const SizedBox(height: 20),
                    ],
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppScript.familyFor(text),
                        fontSize: fontSize,
                        height: 1.8,
                        color: AppColors.ink,
                      ),
                    ),
                    if (secondary != null && secondary!.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      Text(
                        secondary!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppScript.familyFor(secondary!),
                          fontSize: fontSize * 0.78,
                          height: 1.6,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          BlocBuilder<LikeBloc, LikeState>(
            builder: (ctx2, likeState) => BlocBuilder<BookmarkBloc, BookmarkState>(
              builder: (ctx, bookmarkState) {
                final bookmarked = bookmarkState.isBookmarked(contentId);
                return EngageActions(
                  isBookmarked: bookmarked,
                  isLiked: likeState.isLiked(contentId),
                  onBookmark: () => requireAuth(context, () {
                    if (bookmarked) {
                      final bid = bookmarkState.bookmarkIdFor(contentId);
                      if (bid != null) ctx.read<BookmarkBloc>().add(RemoveBookmarkEvent(bookmarkId: bid));
                    } else {
                      ctx.read<BookmarkBloc>().add(AddBookmarkEvent(contentId: contentId, contentType: contentType));
                    }
                  }),
                  onLike: likeState.isPending(contentId) ? null : () => requireAuth(context, () => ctx2.read<LikeBloc>().add(ToggleLikeEvent(contentId: contentId))),
                  onComment: () => onComment(context: context, commentFormId: contentId),
                  onShare: () async {
                    final result = await Share.share(shareText);
                    if (result.status == ShareResultStatus.success) {
                      NotificationService.showSnackbar(text: "Shared successfully", color: Colors.green);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
