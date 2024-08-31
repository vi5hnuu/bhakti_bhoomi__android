part of 'vratKatha_bloc.dart';

@immutable
abstract class VratKathaEvent {
  final CancelToken? cancelToken;
  const VratKathaEvent({this.cancelToken});
}

class FetchVratKathaInfoPage extends VratKathaEvent {
  final int pageNo;
  const FetchVratKathaInfoPage({required this.pageNo,super.cancelToken});
}

class FetchVratKathInfo extends VratKathaEvent {
  final String kathaId;
  const FetchVratKathInfo({required this.kathaId,super.cancelToken});
}

class FetchVratKathaById extends VratKathaEvent {
  final String kathaId;
  const FetchVratKathaById({required this.kathaId,super.cancelToken});
}

class FetchVratKathaByTitle extends VratKathaEvent {
  final String kathaTitle;
  const FetchVratKathaByTitle({required this.kathaTitle,super.cancelToken});
}
