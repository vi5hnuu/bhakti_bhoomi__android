part of 'chalisa_bloc.dart';

@immutable
class ChalisaState extends Equatable {
  final bool isLoading;
  final String? error;
  final Map<String, String>? _chalisaInfo; //chalisaId,chalisaTitle
  final Map<String, ChalisaModel> _chalisa; //chalisaId,ChalisaModel

  const ChalisaState({
    this.isLoading = true,
    this.error,
    Map<String, String>? chalisaInfo,
    Map<String, ChalisaModel> chalisa = const {},
  })  : _chalisa = chalisa,
        _chalisaInfo = chalisaInfo;

  ChalisaState copyWith({
    bool? isLoading,
    String? error,
    Map<String, String>? chalisaInfo,
    Map<String, ChalisaModel>? chalisa,
  }) {
    return ChalisaState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      chalisaInfo: chalisaInfo ?? this._chalisaInfo,
      chalisa: chalisa ?? this._chalisa,
    );
  }

  factory ChalisaState.initial() => const ChalisaState();

  Map<String, String>? get chalisaInfos => _chalisaInfo != null ? Map.unmodifiable(_chalisaInfo) : null;

  Map<String, ChalisaModel> get allChalisa => Map.unmodifiable(_chalisa);

  ChalisaModel? getChalisaById({required String chalisaId}) => _chalisa[chalisaId];

  bool chalisaExists({required String chalisaId}) => _chalisa.containsKey(chalisaId);

  MapEntry<String, ChalisaModel> getChalisaEntry({required ChalisaModel chalisa}) => MapEntry(chalisa.id, chalisa);

  @override
  List<Object?> get props => [isLoading, error, _chalisaInfo, _chalisa];
}
