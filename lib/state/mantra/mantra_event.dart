part of 'mantra_bloc.dart';

@immutable
abstract class MantraEvent {
  final CancelToken? cancelToken;
  const MantraEvent({this.cancelToken});
}

class FetchAllMantraInfo extends MantraEvent {
  const FetchAllMantraInfo({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
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
