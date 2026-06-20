part of 'brahma_sutra_bloc.dart';

@immutable
abstract class BrahmaSutraEvent {
  final CancelToken? cancelToken;
  const BrahmaSutraEvent({this.cancelToken});
}

class FetchBrahmasutraInfo extends BrahmaSutraEvent {
  const FetchBrahmasutraInfo({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchBrahmasutraByChapterNoQuaterNoSutraNo extends BrahmaSutraEvent {
  final int chapterNo;
  final int quaterNo;
  final int sutraNo;
  final String? lang;

  const FetchBrahmasutraByChapterNoQuaterNoSutraNo({required this.chapterNo, required this.quaterNo, required this.sutraNo, this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

