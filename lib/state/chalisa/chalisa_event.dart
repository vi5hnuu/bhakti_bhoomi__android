part of 'chalisa_bloc.dart';

@immutable
abstract class ChalisaEvent {
  final CancelToken? cancelToken;
  const ChalisaEvent({this.cancelToken});
}

class FetchAllChalisaInfo extends ChalisaEvent {
  const FetchAllChalisaInfo({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchAllChalisa extends ChalisaEvent {
  const FetchAllChalisa({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchChalisaById extends ChalisaEvent {
  final String id;
  const FetchChalisaById({required this.id, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchChalisaByTitle extends ChalisaEvent {
  final String title;
  const FetchChalisaByTitle({required this.title, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}
