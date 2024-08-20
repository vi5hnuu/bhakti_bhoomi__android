part of 'guru_granth_sahib_bloc.dart';

@immutable
class GuruGranthSahibState extends Equatable with WithHttpState {
  final GuruGranthSahibInfoModel? _guruGranthSahibInfo;
  final Map<String, GuruGranthSahibRagaModel> _guruGranthSahibRagas; //ragaNo-partNo,raga

  GuruGranthSahibState({Map<String,HttpState>? httpStates, GuruGranthSahibInfoModel? guruGranthSahibInfo, Map<String, GuruGranthSahibRagaModel>? guruGranthSahibRagas}):_guruGranthSahibInfo=guruGranthSahibInfo,_guruGranthSahibRagas=guruGranthSahibRagas ?? {}{
    this.httpStates.addAll(httpStates ?? {});
  }

  GuruGranthSahibState copyWith({
    Map<String, HttpState>? httpStates,
    GuruGranthSahibInfoModel? guruGranthSahibInfo,
    Map<String, GuruGranthSahibRagaModel>? guruGranthSahibRagas
  }) {
    return GuruGranthSahibState(
      httpStates: httpStates ?? this.httpStates,
      guruGranthSahibInfo:guruGranthSahibInfo ?? _guruGranthSahibInfo,
      guruGranthSahibRagas:guruGranthSahibRagas ?? _guruGranthSahibRagas
    );
  }

  factory GuruGranthSahibState.initial() => GuruGranthSahibState();

  String _uniqueKey({required int ragaNo, required int partNo}) => "$ragaNo-$partNo}";

  MapEntry<String, GuruGranthSahibRagaModel> getEntry(GuruGranthSahibRagaModel raga) => MapEntry(_uniqueKey(ragaNo: raga.ragaNo, partNo: raga.partNo), raga);

  bool ragaExists({required int ragaNo, required int partNo}) => _guruGranthSahibRagas.containsKey(_uniqueKey(ragaNo: ragaNo, partNo: partNo));

  GuruGranthSahibRagaModel? getRaga({required int ragaNo, required int partNo}) => _guruGranthSahibRagas[_uniqueKey(ragaNo: ragaNo, partNo: partNo)];
  Map<String, GuruGranthSahibRagaModel> getRagas() => Map.unmodifiable(_guruGranthSahibRagas);
  GuruGranthSahibInfoModel? getInfo() => _guruGranthSahibInfo;

  @override
  List<Object?> get props => [httpStates, _guruGranthSahibRagas, _guruGranthSahibInfo];
}
