part of 'yoga_sutra_bloc.dart';

@immutable
abstract class YogaSutraEvent {
  final CancelToken? cancelToken;
  const YogaSutraEvent({this.cancelToken});
}

class FetchYogasutraInfo extends YogaSutraEvent {
  const FetchYogasutraInfo({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchYogasutraBySutraId extends YogaSutraEvent {
  final String sutraId;
  final String? lang;

  const FetchYogasutraBySutraId({required this.sutraId, this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchYogasutraByChapterNoSutraNo extends YogaSutraEvent {
  final int chapterNo;
  final int sutraNo;
  final String? lang;

  const FetchYogasutraByChapterNoSutraNo({required this.chapterNo, required this.sutraNo, this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchYogasutrasByChapterNo extends YogaSutraEvent {
  final int chapterNo;
  final int? pageNo;
  final int? pageSize;
  final String? lang;

  const FetchYogasutrasByChapterNo({required this.chapterNo, this.pageNo, this.pageSize, this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}
