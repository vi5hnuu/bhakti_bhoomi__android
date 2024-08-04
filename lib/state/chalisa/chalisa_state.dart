part of 'chalisa_bloc.dart';

@immutable
class ChalisaState extends Equatable with WithHttpState {
  final Map<String, String>? _chalisaInfo; //chalisaId,chalisaTitle
  final Map<String, ChalisaModel> _chalisa; //chalisaId,ChalisaModel

  ChalisaState({
    Map<String,HttpState>? httpStates,
    Map<String, String>? chalisaInfo,
    Map<String, ChalisaModel> chalisa = const {},
  })  : _chalisa = chalisa,
        _chalisaInfo = chalisaInfo{
    this.httpStates.addAll(httpStates ?? {});
  }

  ChalisaState copyWith({
    Map<String, HttpState>? httpStates,
    Map<String, String>? chalisaInfo,
    Map<String, ChalisaModel>? chalisa,
  }) {
    return ChalisaState(
      httpStates: httpStates ?? this.httpStates,
      chalisaInfo: chalisaInfo ?? this._chalisaInfo,
      chalisa: chalisa ?? this._chalisa,
    );
  }

  factory ChalisaState.initial() => ChalisaState();

  Map<String, String>? get chalisaInfos => _chalisaInfo != null ? Map.unmodifiable(_chalisaInfo) : null;

  Map<String, ChalisaModel> get allChalisa => Map.unmodifiable(_chalisa);

  ChalisaModel? getChalisaById({required String chalisaId}) => _chalisa[chalisaId];

  bool chalisaExists({required String chalisaId}) => _chalisa.containsKey(chalisaId);

  MapEntry<String, ChalisaModel> getChalisaEntry({required ChalisaModel chalisa}) => MapEntry(chalisa.id, chalisa);

  @override
  List<Object?> get props => [httpStates, _chalisaInfo, _chalisa];
}
