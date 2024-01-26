part of 'bhagvad_geeta_bloc.dart';

@immutable
abstract class BhagvadGeetaEvent {
  final CancelToken? cancelToken;
  const BhagvadGeetaEvent({this.cancelToken});
}

class FetchBhagvadGeetaChapters extends BhagvadGeetaEvent {
  const FetchBhagvadGeetaChapters({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchBhagvadShlokByChapterIdShlokId extends BhagvadGeetaEvent {
  final String chapterId;
  final String shlokId;

  const FetchBhagvadShlokByChapterIdShlokId({required this.chapterId, required this.shlokId, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchBhagvadShlokByChapterIdShlokNo extends BhagvadGeetaEvent {
  final String chapterId;
  final int shlokNo;

  const FetchBhagvadShlokByChapterIdShlokNo({required this.chapterId, required this.shlokNo, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchBhagvadShlokByChapterNoShlokNo extends BhagvadGeetaEvent {
  final int chapterNo;
  final int shlokNo;

  const FetchBhagvadShlokByChapterNoShlokNo({required this.chapterNo, required this.shlokNo, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchBhagvadGeetaShloks extends BhagvadGeetaEvent {
  final String chapterId;
  final int? pageNo;
  final int? pageSize;
  const FetchBhagvadGeetaShloks({required this.chapterId, this.pageNo, this.pageSize, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}
