part of 'yoga_sutra_bloc.dart';

@immutable
class YogaSutraState extends Equatable {
  final bool isLoading;
  final String? error;
  final YogaSutraInfoModel? yogaSutraInfo;
  final Map<String, YogaSutraModel> _sutras; //sutraId,sutra

  const YogaSutraState({
    this.isLoading = false,
    this.error,
    this.yogaSutraInfo,
    Map<String, YogaSutraModel> sutras = const {},
  }) : _sutras = sutras;

  YogaSutraState copyWith({
    bool? isLoading,
    String? error,
    YogaSutraInfoModel? yogaSutraInfo,
    Map<String, YogaSutraModel>? sutras,
  }) {
    return YogaSutraState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      yogaSutraInfo: yogaSutraInfo ?? this.yogaSutraInfo,
      sutras: sutras ?? this._sutras,
    );
  }

  factory YogaSutraState.initial() => const YogaSutraState();
  factory YogaSutraState.loading() => const YogaSutraState(isLoading: true);
  factory YogaSutraState.failure(String error) => YogaSutraState(error: error);
  factory YogaSutraState.success(YogaSutraInfoModel yogaSutraInfo, Map<String, YogaSutraModel> sutras) => YogaSutraState(yogaSutraInfo: yogaSutraInfo, sutras: sutras);

  get sutras => Map.unmodifiable(_sutras);
  void addSutra(YogaSutraModel sutra) => _sutras[sutra.id] = sutra;

  @override
  List<Object?> get props => [isLoading, error, yogaSutraInfo, _sutras];
}
