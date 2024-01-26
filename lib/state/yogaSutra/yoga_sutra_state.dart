part of 'yoga_sutra_bloc.dart';

@immutable
class YogaSutraState extends Equatable {
  final bool isLoading;
  final String? error;
  final YogaSutraInfoModel? yogaSutraInfo;
  final Map<String, YogaSutraModel> _sutras; //sutraId,sutra

  const YogaSutraState({
    this.isLoading = true,
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
      error: error,
      yogaSutraInfo: yogaSutraInfo ?? this.yogaSutraInfo,
      sutras: sutras ?? this._sutras,
    );
  }

  factory YogaSutraState.initial() => const YogaSutraState();

  get sutras => Map.unmodifiable(_sutras);

  @override
  List<Object?> get props => [isLoading, error, yogaSutraInfo, _sutras];
}
