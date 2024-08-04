part of 'mantra_bloc.dart';

@immutable
class MantraState extends Equatable with WithHttpState {
  final Map<String, MantraInfoModel>? _mantraInfo; //mantraInfo
  final Map<String, MantraGroupModel> _mantras; //mantraId,mantra

  MantraState({
    Map<String,HttpState>? httpStates,
    Map<String, MantraInfoModel>? mantraInfo,
    Map<String, MantraGroupModel> mantras = const {},
  })  : _mantras = mantras,
        _mantraInfo = mantraInfo{
    this.httpStates.addAll(httpStates ?? {});
  }

  MantraState copyWith({
    Map<String, HttpState>? httpStates,
    Map<String, MantraInfoModel>? mantraInfo,
    Map<String, MantraGroupModel>? mantras,
  }) {
    return MantraState(
      httpStates: httpStates ?? this.httpStates,
      mantraInfo: mantraInfo ?? this._mantraInfo,
      mantras: mantras ?? this._mantras,
    );
  }

  factory MantraState.initial() => MantraState();

  Map<String, MantraInfoModel>? get allMantraInfo => _mantraInfo != null ? Map.unmodifiable(_mantraInfo) : null;

  Map<String, MantraGroupModel> get allMantras => Map.unmodifiable(_mantras);

  bool mantraExists({required String mantraId}) => _mantras.containsKey(mantraId);

  MantraGroupModel? getMantraById({required String mantraId}) => _mantras[mantraId];

  MapEntry<String, MantraGroupModel> getMantraEntry({required MantraGroupModel mantra}) => MapEntry(mantra.id, mantra);

  @override
  List<Object?> get props => [httpStates, _mantraInfo, _mantras];
}
