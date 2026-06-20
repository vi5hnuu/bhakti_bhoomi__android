part of 'ramcharitmanas_bloc.dart';

@immutable
abstract class RamcharitmanasEvent {
  final CancelToken? cancelToken;
  const RamcharitmanasEvent({this.cancelToken});
}

class FetchRamcharitmanasInfo extends RamcharitmanasEvent {
  const FetchRamcharitmanasInfo({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
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

