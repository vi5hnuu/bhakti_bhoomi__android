part of 'bookmark_bloc.dart';

@immutable
class BookmarkState extends Equatable {
  final List<BookmarkModel> bookmarks;
  final bool isLoading;
  final String? pendingContentId; // contentId currently being added/removed
  final Map<String, bool> checkedBookmarkStatus; // contentId -> isBookmarked

  const BookmarkState({
    this.bookmarks = const [],
    this.isLoading = false,
    this.pendingContentId,
    this.checkedBookmarkStatus = const {},
  });

  bool isBookmarked(String contentId) =>
      bookmarks.any((b) => b.contentId == contentId) ||
      (checkedBookmarkStatus[contentId] ?? false);

  String? bookmarkIdFor(String contentId) =>
      bookmarks.firstWhere((b) => b.contentId == contentId, orElse: () => const BookmarkModel(id: '', contentId: '', contentType: '')).id.isEmpty
          ? null
          : bookmarks.firstWhere((b) => b.contentId == contentId).id;

  BookmarkState copyWith({
    List<BookmarkModel>? bookmarks,
    bool? isLoading,
    String? pendingContentId,
    bool clearPending = false,
    Map<String, bool>? checkedBookmarkStatus,
  }) {
    return BookmarkState(
      bookmarks: bookmarks ?? this.bookmarks,
      isLoading: isLoading ?? this.isLoading,
      pendingContentId: clearPending ? null : (pendingContentId ?? this.pendingContentId),
      checkedBookmarkStatus: checkedBookmarkStatus ?? this.checkedBookmarkStatus,
    );
  }

  @override
  List<Object?> get props => [bookmarks, isLoading, pendingContentId, checkedBookmarkStatus];
}
