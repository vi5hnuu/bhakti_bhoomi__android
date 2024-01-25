part of 'ramayan_bloc.dart';

@immutable
class RamayanState extends Equatable {
  final bool isLoading;
  final String? error;
  final RamayanInfoModel? ramayanInfo;
  final Map<String, RamayanKandaInfoModel> _kandaInfo; //kanda,kandaInfo
  final Map<String, RamayanSargaInfoModel> _sargaInfo; //sargaId,sargaInfo
  final Map<String, RamayanShlokModel> _shloks; //uniqueIdentifier,shlok

  String _uniqueShlokIdentifier(RamayanShlokModel ramayanShlokModel) {
    return "${ramayanShlokModel.kand}_${ramayanShlokModel.shlokNo}_${ramayanShlokModel.shlokLang}";
  }

  RamayanState({
    this.isLoading = true,
    this.error,
    this.ramayanInfo,
    Map<String, RamayanKandaInfoModel> kandaInfo = const {},
    Map<String, RamayanSargaInfoModel> sargaInfo = const {},
    Map<String, RamayanShlokModel> shloks = const {},
  })  : _shloks = shloks,
        _sargaInfo = sargaInfo,
        _kandaInfo = kandaInfo;

  RamayanState copyWith({
    bool? isLoading,
    String? error,
    RamayanInfoModel? ramayanInfo,
    Map<String, RamayanKandaInfoModel>? kandaInfo,
    Map<String, RamayanSargaInfoModel>? sargaInfo,
    Map<String, RamayanShlokModel>? shloks,
  }) {
    return RamayanState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      ramayanInfo: ramayanInfo ?? this.ramayanInfo,
      kandaInfo: kandaInfo ?? this._kandaInfo,
      sargaInfo: sargaInfo ?? this._sargaInfo,
      shloks: shloks ?? this._shloks,
    );
  }

  factory RamayanState.initial() => RamayanState();

  get allKandaInfo => Map.unmodifiable(_kandaInfo);

  get allSargaInfo => Map.unmodifiable(_sargaInfo);

  get allShloks => Map.unmodifiable(_shloks);

  @override
  List<Object?> get props => [
        isLoading,
        error,
        ramayanInfo,
        _kandaInfo,
        _sargaInfo,
        _shloks,
      ];
}
