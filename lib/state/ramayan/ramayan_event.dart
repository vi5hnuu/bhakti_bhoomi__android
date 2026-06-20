part of 'ramayan_bloc.dart';

@immutable
abstract class RamayanEvent {
  final CancelToken? cancelToken;
  const RamayanEvent({this.cancelToken});
}

class FetchRamayanInfo extends RamayanEvent {
  const FetchRamayanInfo({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchRamayanSargasInfo extends RamayanEvent {
  final String kanda;
  final int pageNo;
  const FetchRamayanSargasInfo({required this.kanda, required this.pageNo, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchRamayanShlokByKandSargaNoShlokNo extends RamayanEvent {
  final String kanda;
  final int sargaNo;
  final int shlokNo;
  final String? lang;

  const FetchRamayanShlokByKandSargaNoShlokNo({required this.kanda, required this.sargaNo, required this.shlokNo, this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

