part of 'rigveda_bloc.dart';

@immutable
abstract class RigvedaEvent {
  final CancelToken? cancelToken;
  const RigvedaEvent({this.cancelToken});
}

class FetchRigvedaInfo extends RigvedaEvent {
  const FetchRigvedaInfo({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchVerseByMandalaSukta extends RigvedaEvent {
  final int mandalaNo;
  final int suktaNo;

  const FetchVerseByMandalaSukta({required this.mandalaNo, required this.suktaNo, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchVerseBySuktaId extends RigvedaEvent {
  final String suktaId;

  const FetchVerseBySuktaId({required this.suktaId, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchVersesByMandala extends RigvedaEvent {
  final int mandalaNo;
  final int? pageNo;
  final int? pageSize;

  const FetchVersesByMandala({required this.mandalaNo, this.pageNo, this.pageSize, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}
