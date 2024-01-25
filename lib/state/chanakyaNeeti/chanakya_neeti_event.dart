part of 'chanakya_neeti_bloc.dart';

@immutable
abstract class ChanakyaNeetiEvent {
  final CancelToken? cancelToken;
  const ChanakyaNeetiEvent({this.cancelToken});
}

class FetchChanakyaNeetiChaptersInfo extends ChanakyaNeetiEvent {
  const FetchChanakyaNeetiChaptersInfo({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchChanakyaNeetiChapterVerses extends ChanakyaNeetiEvent {
  final int chapterNo;

  const FetchChanakyaNeetiChapterVerses({required this.chapterNo, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchChanakyaNeetiVerseByChapterNoVerseNo extends ChanakyaNeetiEvent {
  final int chapterNo;
  final int verseNo;

  const FetchChanakyaNeetiVerseByChapterNoVerseNo({required this.chapterNo, required this.verseNo, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}
