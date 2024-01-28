part of 'ramayan_bloc.dart';

@immutable
class RamayanState extends Equatable {
  final bool isLoading;
  final String? error;
  final RamayanInfoModel? ramayanInfo;
  final Map<String, RamayanSargaInfoModel> _sargaInfo; //_uniqueKey,sargaInfo
  final Map<String, RamayanShlokModel> _shloks; //uniqueKey,shlok
  static final defaultLanguage = "dv";
  static final defaultSargasInfoPageSize = 15;

  RamayanState({this.isLoading = true, this.error, this.ramayanInfo, Map<String, RamayanSargaInfoModel> sargaInfo = const {}, Map<String, RamayanShlokModel> shloks = const {}})
      : _shloks = shloks,
        _sargaInfo = sargaInfo;

  RamayanState copyWith({bool? isLoading, String? error, RamayanInfoModel? ramayanInfo, Map<String, RamayanSargaInfoModel>? sargaInfo, Map<String, RamayanShlokModel>? shloks}) {
    return RamayanState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      ramayanInfo: ramayanInfo ?? this.ramayanInfo,
      shloks: shloks ?? _shloks,
      sargaInfo: sargaInfo ?? _sargaInfo,
    );
  }

  String _uniqueShlokIdentifier({required String kanda, required int sargaNo, required int shlokNo, String? lang}) {
    return "${kanda}_${sargaNo}_${shlokNo}_${lang ?? defaultLanguage}";
  }

  MapEntry<String, RamayanShlokModel> getShlokEntry(RamayanShlokModel ramayanShlok) {
    return MapEntry<String, RamayanShlokModel>(
        _uniqueShlokIdentifier(kanda: ramayanShlok.kanda, sargaNo: ramayanShlok.sargaNo, shlokNo: ramayanShlok.shlokNo, lang: ramayanShlok.language), ramayanShlok);
  }

  String _uniqueSargaIdentifier({required String kanda, required int sargaNo}) {
    return "${kanda}_${sargaNo}";
  }

  MapEntry<String, RamayanSargaInfoModel> getSargaInfoEntry(RamayanSargaInfoModel ramayanSargaInfo) {
    return MapEntry<String, RamayanSargaInfoModel>(_uniqueSargaIdentifier(kanda: ramayanSargaInfo.kanda, sargaNo: ramayanSargaInfo.sargaNo), ramayanSargaInfo);
  }

  factory RamayanState.initial() => RamayanState();

  Map<String, RamayanSargaInfoModel> get allSargaInfo => Map.unmodifiable(_sargaInfo);

  Map<String, RamayanShlokModel> get allShloks => Map.unmodifiable(_shloks);

  bool sargaInfoExists({required String kanda, required int sargaNo}) {
    return _sargaInfo.containsKey(_uniqueSargaIdentifier(kanda: kanda, sargaNo: sargaNo));
  }

  bool sargasInfoExists({required String kanda, required int pageNo}) {
    return List.generate(defaultSargasInfoPageSize, (index) => index + 1).every((sargaNo) => sargaInfoExists(kanda: kanda, sargaNo: sargaNo));
  }

  List<RamayanSargaInfoModel?> getPageSargasInfo({required String kanda, required int pageNo}) {
    return List.generate(defaultSargasInfoPageSize, (index) => index + 1 + (pageNo - 1) * defaultSargasInfoPageSize).map((sargaNo) => getSargaInfo(kanda: kanda, sargaNo: sargaNo)).toList();
  }

  bool shlokExists({required String kanda, required int sargaNo, required int shlokNo, String? lang}) {
    return _shloks.containsKey(_uniqueShlokIdentifier(kanda: kanda, sargaNo: sargaNo, shlokNo: shlokNo, lang: lang ?? defaultLanguage));
  }

  RamayanSargaInfoModel? getSargaInfo({required String kanda, required int sargaNo}) {
    return _sargaInfo[_uniqueSargaIdentifier(kanda: kanda, sargaNo: sargaNo)];
  }

  RamayanShlokModel? getShlok({required String kanda, required int sargaNo, required int shlokNo, String? lang}) {
    return _shloks[_uniqueShlokIdentifier(kanda: kanda, sargaNo: sargaNo, shlokNo: shlokNo, lang: lang ?? defaultLanguage)];
  }

  List<MapEntry<String, int>>? kandas() {
    return ramayanInfo?.kandaOrder.entries.toList(growable: false)?..sort((a, b) => a.value.compareTo(b.value));
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        ramayanInfo,
        _sargaInfo,
        _shloks,
      ];
}
