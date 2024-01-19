part of 'mantra_bloc.dart';

@immutable
class MantraState extends Equatable {
  final bool isLoading;
  final String? error;
  final Map<String, MantraInfoModel> _mantraInfo; //mantraId,mantraInfo
  final Map<String, MantraModel> _mantras; //mantraId,mantra

  MantraState({
    this.isLoading = false,
    this.error,
    Map<String, MantraInfoModel> mantraInfo = const {},
    Map<String, MantraModel> mantras = const {},
  })  : _mantras = mantras,
        _mantraInfo = mantraInfo;

  MantraState copyWith({
    bool? isLoading,
    String? error,
    Map<String, MantraInfoModel>? mantraInfo,
    Map<String, MantraModel>? mantras,
  }) {
    return MantraState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      mantraInfo: mantraInfo ?? this._mantraInfo,
      mantras: mantras ?? this._mantras,
    );
  }

  factory MantraState.initial() => MantraState();
  factory MantraState.loading() => MantraState(isLoading: true);
  factory MantraState.error(String error) => MantraState(error: error);
  factory MantraState.success(Map<String, MantraInfoModel> mantraInfo, Map<String, MantraModel> mantras) => MantraState(mantraInfo: mantraInfo, mantras: mantras);

  get allMantraInfo => Map.unmodifiable(_mantraInfo);
  void addMantraInfo(MantraInfoModel mantraInfo) => _mantraInfo[mantraInfo.id] = mantraInfo;

  get allMantras => Map.unmodifiable(_mantras);
  void addMantra(MantraModel mantra) => _mantras[mantra.id] = mantra;

  @override
  List<Object?> get props => [isLoading, error, _mantraInfo, _mantras];
}
