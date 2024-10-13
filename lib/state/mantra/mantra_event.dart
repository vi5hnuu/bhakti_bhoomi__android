part of 'mantra_bloc.dart';

@immutable
abstract class MantraEvent {
  final CancelToken? cancelToken;
  const MantraEvent({this.cancelToken});
}

class FetchAllMantraInfo extends MantraEvent {
  const FetchAllMantraInfo({super.cancelToken});
}

class FetchAllMantraAudioInfo extends MantraEvent {
  final int pageNo;
  const FetchAllMantraAudioInfo({required this.pageNo,super.cancelToken});
}

class FetchAllMantra extends MantraEvent {
  const FetchAllMantra({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchMantraById extends MantraEvent {
  final String id;

  const FetchMantraById({required this.id, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchMantraByTitle extends MantraEvent {
  final String title;

  const FetchMantraByTitle({required this.title, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchMantraAudioById extends MantraEvent {
  final String id;

  const FetchMantraAudioById({required this.id, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchMantraAudioByTitle extends MantraEvent {
  final String title;

  const FetchMantraAudioByTitle({required this.title, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}
