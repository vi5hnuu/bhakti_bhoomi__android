part of 'bhagvad_geeta_bloc.dart';

@immutable
abstract class BhagvadGeetaEvent {
  final CancelToken? cancelToken;
  const BhagvadGeetaEvent({this.cancelToken});
}

class FetchBhagvadGeetaChapters extends BhagvadGeetaEvent {
  const FetchBhagvadGeetaChapters({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchBhagvadGeetaChapter extends BhagvadGeetaEvent {
  final String chapterId;
  const FetchBhagvadGeetaChapter({required this.chapterId, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchBhagvadShlokByChapterIdShlokId extends BhagvadGeetaEvent {
  final String chapterId;
  final String shlokId;

  const FetchBhagvadShlokByChapterIdShlokId({required this.chapterId, required this.shlokId, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchBhagvadGeetaShloks extends BhagvadGeetaEvent {
  final String chapterId;
  final int? pageNo;
  final int? pageSize;
  const FetchBhagvadGeetaShloks({required this.chapterId, this.pageNo, this.pageSize, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}
