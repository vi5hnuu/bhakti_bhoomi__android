part of 'aarti_bloc.dart';

@immutable
abstract class AartiEvent {
  final CancelToken? cancelToken;
  const AartiEvent({this.cancelToken});
}

class FetchAartiInfoEvent extends AartiEvent {
  const FetchAartiInfoEvent({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchAartiEvent extends AartiEvent {
  final String aartiId;
  const FetchAartiEvent({required this.aartiId, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}
