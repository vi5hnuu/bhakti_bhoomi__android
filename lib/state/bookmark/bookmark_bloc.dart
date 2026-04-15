import 'package:bhakti_bhoomi/models/bookmark/BookmarkModel.dart';
import 'package:bhakti_bhoomi/services/bookmark/BookmarkRepository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final BookmarkRepository _repository;

  BookmarkBloc({BookmarkRepository? repository})
      : _repository = repository ?? BookmarkRepository(),
        super(const BookmarkState()) {
    on<FetchBookmarksEvent>(_onFetch);
    on<AddBookmarkEvent>(_onAdd);
    on<RemoveBookmarkEvent>(_onRemove);
    on<CheckBookmarkEvent>(_onCheck);
  }

  Future<void> _onFetch(FetchBookmarksEvent event, Emitter<BookmarkState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final res = await _repository.getMyBookmarks(cancelToken: event.cancelToken);
      emit(state.copyWith(isLoading: false, bookmarks: res.data ?? []));
    } on DioException {
      emit(state.copyWith(isLoading: false));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onAdd(AddBookmarkEvent event, Emitter<BookmarkState> emit) async {
    emit(state.copyWith(pendingContentId: event.contentId));
    try {
      final res = await _repository.addBookmark(
          contentId: event.contentId, contentType: event.contentType, cancelToken: event.cancelToken);
      if (res.success && res.data != null) {
        final updated = [...state.bookmarks, res.data!];
        emit(state.copyWith(bookmarks: updated, pendingContentId: null));
      }
    } on DioException {
      emit(state.copyWith(pendingContentId: null));
    } catch (_) {
      emit(state.copyWith(pendingContentId: null));
    }
  }

  Future<void> _onRemove(RemoveBookmarkEvent event, Emitter<BookmarkState> emit) async {
    emit(state.copyWith(pendingContentId: event.bookmarkId));
    try {
      await _repository.removeBookmark(bookmarkId: event.bookmarkId, cancelToken: event.cancelToken);
      final updated = state.bookmarks.where((b) => b.id != event.bookmarkId).toList();
      emit(state.copyWith(bookmarks: updated, pendingContentId: null));
    } on DioException {
      emit(state.copyWith(pendingContentId: null));
    } catch (_) {
      emit(state.copyWith(pendingContentId: null));
    }
  }

  Future<void> _onCheck(CheckBookmarkEvent event, Emitter<BookmarkState> emit) async {
    try {
      final res = await _repository.isBookmarked(contentId: event.contentId, cancelToken: event.cancelToken);
      if (res.success) {
        emit(state.copyWith(checkedBookmarkStatus: {
          ...state.checkedBookmarkStatus,
          event.contentId: res.data ?? false,
        }));
      }
    } catch (_) {}
  }
}
