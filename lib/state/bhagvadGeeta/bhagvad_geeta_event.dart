part of 'bhagvad_geeta_bloc.dart';

@immutable
abstract class BhagvadGeetaEvent {
  final CancelToken? cancelToken;
  const BhagvadGeetaEvent({this.cancelToken});
}

class FetchBhagvadGeetaChapters extends BhagvadGeetaEvent {
  const FetchBhagvadGeetaChapters({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchBhagvadShlokByChapterNoShlokNo extends BhagvadGeetaEvent {
  final int chapterNo;
  final int shlokNo;

  const FetchBhagvadShlokByChapterNoShlokNo({required this.chapterNo, required this.shlokNo, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

