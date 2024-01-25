part of 'ramcharitmanas_bloc.dart';

@immutable
abstract class RamcharitmanasEvent {
  final CancelToken? cancelToken;
  const RamcharitmanasEvent({this.cancelToken});
}

class FetchRamcharitmanasInfo extends RamcharitmanasEvent {
  const FetchRamcharitmanasInfo({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchRamcharitmanasVerseById extends RamcharitmanasEvent {
  final String id;
  final String? lang;

  const FetchRamcharitmanasVerseById({required this.id, this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchRamcharitmanasVerseByKandaAndVerseNo extends RamcharitmanasEvent {
  final String kanda;
  final int verseNo;
  final String? lang;

  const FetchRamcharitmanasVerseByKandaAndVerseNo({required this.kanda, required this.verseNo, this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchRamcharitmanasMangalacharanByKanda extends RamcharitmanasEvent {
  final String kanda;
  final String? lang;

  const FetchRamcharitmanasMangalacharanByKanda({required this.kanda, this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchRamcharitmanasAllMangalacharan extends RamcharitmanasEvent {
  final String? lang;

  const FetchRamcharitmanasAllMangalacharan({this.lang, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchRamcharitmanasVersesByKand extends RamcharitmanasEvent {
  final String kanda;
  final String? lang;
  final int? pageNo;
  final int? pageSize;

  const FetchRamcharitmanasVersesByKand({required this.kanda, this.lang, this.pageNo, this.pageSize, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}
