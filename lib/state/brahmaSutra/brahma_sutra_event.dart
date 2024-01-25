part of 'brahma_sutra_bloc.dart';

@immutable
abstract class BrahmaSutraEvent {
  final CancelToken? cancelToken;
  const BrahmaSutraEvent({this.cancelToken});
}

class FetchBrahmasutraInfo extends BrahmaSutraEvent {
  const FetchBrahmasutraInfo({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchBrahmasutraBySutraId extends BrahmaSutraEvent {
  final String sutraId;
  final String? lang;

  const FetchBrahmasutraBySutraId({required this.sutraId, this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchBrahmasutraByChapterNoQuaterNoSutraNo extends BrahmaSutraEvent {
  final int chapterNo;
  final int quaterNo;
  final int sutraNo;
  final String? lang;

  const FetchBrahmasutraByChapterNoQuaterNoSutraNo({required this.chapterNo, required this.quaterNo, required this.sutraNo, this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchBrahmasutrasByChapterNoQuaterNo extends BrahmaSutraEvent {
  final int chapterNo;
  final int quaterNo;
  final int? pageNo;
  final int? pageSize;
  final String? lang;

  const FetchBrahmasutrasByChapterNoQuaterNo({required this.chapterNo, required this.quaterNo, this.pageNo, this.pageSize, this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}
