part of 'mahabharat_bloc.dart';

@immutable
abstract class MahabharatEvent {
  final CancelToken? cancelToken;
  const MahabharatEvent({this.cancelToken});
}

class FetchMahabharatInfoEvent extends MahabharatEvent {}

class FetchMahabharatShlokById extends MahabharatEvent {
  final String id;
  const FetchMahabharatShlokById({required this.id, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchMahabharatShlokByShlokNo extends MahabharatEvent {
  final int bookNo;
  final int chapterNo;
  final int shlokNo;

  const FetchMahabharatShlokByShlokNo({required this.bookNo, required this.chapterNo, required this.shlokNo, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchMahabharatShloksByBookChapter extends MahabharatEvent {
  final int bookNo;
  final int chapterNo;
  final int? pageNo;
  final int? pageSize;

  const FetchMahabharatShloksByBookChapter({required this.bookNo, required this.chapterNo, this.pageNo, this.pageSize, CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}
