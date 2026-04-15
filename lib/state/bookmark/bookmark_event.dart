part of 'bookmark_bloc.dart';

@immutable
abstract class BookmarkEvent {
  final CancelToken? cancelToken;
  const BookmarkEvent({this.cancelToken});
}

class FetchBookmarksEvent extends BookmarkEvent {
  const FetchBookmarksEvent({super.cancelToken});
}

class AddBookmarkEvent extends BookmarkEvent {
  final String contentId;
  final String contentType;
  const AddBookmarkEvent({required this.contentId, required this.contentType, super.cancelToken});
}

class RemoveBookmarkEvent extends BookmarkEvent {
  final String bookmarkId;
  const RemoveBookmarkEvent({required this.bookmarkId, super.cancelToken});
}

class CheckBookmarkEvent extends BookmarkEvent {
  final String contentId;
  const CheckBookmarkEvent({required this.contentId, super.cancelToken});
}
