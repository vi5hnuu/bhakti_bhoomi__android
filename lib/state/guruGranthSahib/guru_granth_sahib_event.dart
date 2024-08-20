part of 'guru_granth_sahib_bloc.dart';

@immutable
abstract class GuruGranthSahibEvent {
  final CancelToken? cancelToken;
  const GuruGranthSahibEvent({this.cancelToken});
}

class FetchGuruGranthSahibInfo extends GuruGranthSahibEvent {
  const FetchGuruGranthSahibInfo({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchGuruGranthSahibDescription extends GuruGranthSahibEvent {
  const FetchGuruGranthSahibDescription({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}

class FetchGuruGranthSahibRagaByRagaNamePartId extends GuruGranthSahibEvent {
  final String ragaName;
  final String partId;

  const FetchGuruGranthSahibRagaByRagaNamePartId({required this.ragaName, required this.partId, super.cancelToken});
}

class FetchGuruGranthSahibRagaByRagaNamePartNo extends GuruGranthSahibEvent {
  final String ragaName;
  final int partNo;

  const FetchGuruGranthSahibRagaByRagaNamePartNo({required this.ragaName, required this.partNo, super.cancelToken});
}

class FetchGuruGranthSahibRagaByRagaNoPartId extends GuruGranthSahibEvent {
  final int ragaNo;
  final String partId;

  const FetchGuruGranthSahibRagaByRagaNoPartId({required this.ragaNo, required this.partId, super.cancelToken});
}

class FetchGuruGranthSahibRagaByRagaNoPartNo extends GuruGranthSahibEvent {
  final int ragaNo;
  final int partNo;

  const FetchGuruGranthSahibRagaByRagaNoPartNo({required this.ragaNo, required this.partNo, super.cancelToken});
}