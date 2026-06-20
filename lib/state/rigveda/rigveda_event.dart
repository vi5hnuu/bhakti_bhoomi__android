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
