part of 'ramayan_bloc.dart';

@immutable
abstract class RamayanEvent {
  final CancelToken? cancelToken;
  const RamayanEvent({this.cancelToken});
}

class FetchRamayanInfo extends RamayanEvent {
  const FetchRamayanInfo({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchRamayanShlokByKandSargaNoShlokNo extends RamayanEvent {
  final String kanda;
  final int sargaNo;
  final int shlokNo;
  final String? lang;

  const FetchRamayanShlokByKandSargaNoShlokNo({required this.kanda, required this.sargaNo, required this.shlokNo, this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchRamayanShlokByKandSargaIdShlokNo extends RamayanEvent {
  final String kanda;
  final String sargaId;
  final int shlokNo;
  final String? lang;

  const FetchRamayanShlokByKandSargaIdShlokNo({required this.kanda, required this.sargaId, required this.shlokNo, this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchRamayanShlokasByKandSargaNo extends RamayanEvent {
  final String kanda;
  final int sargaNo;
  final int? pageNo;
  final int? pageSize;
  final String? lang;

  const FetchRamayanShlokasByKandSargaNo({required this.kanda, required this.sargaNo, this.pageNo, this.pageSize, this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchRamayanShlokasByKandSargaId extends RamayanEvent {
  final String kanda;
  final String sargaId;
  final int? pageNo;
  final int? pageSize;
  final String? lang;

  const FetchRamayanShlokasByKandSargaId({required this.kanda, required this.sargaId, this.pageNo, this.pageSize, this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}
