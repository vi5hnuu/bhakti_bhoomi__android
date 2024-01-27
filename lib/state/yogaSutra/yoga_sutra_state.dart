part of 'yoga_sutra_bloc.dart';

@immutable
class YogaSutraState extends Equatable {
  final bool isLoading;
  final String? error;
  final YogaSutraInfoModel? yogaSutraInfo;
  final Map<String, YogaSutraModel> _sutras; //sutraId,sutra
  static final defaultLanguage = "dv";

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

  Map<String, YogaSutraModel> get sutras => Map.unmodifiable(_sutras);

  String _uniqueSutraIdentifier({required int chapterNo, required int sutraNo, String? lang}) {
    return "${chapterNo}_${sutraNo}_${lang ?? defaultLanguage}";
  }

  bool sutraExists({required int chapterNo, required int sutraNo, String? lang}) {
    return _sutras.containsKey(_uniqueSutraIdentifier(chapterNo: chapterNo, sutraNo: sutraNo, lang: lang));
  }

  MapEntry<String, YogaSutraModel> getSutraEntry(YogaSutraModel sutra) {
    return MapEntry<String, YogaSutraModel>(_uniqueSutraIdentifier(chapterNo: sutra.chapterNo, sutraNo: sutra.sutraNo, lang: sutra.language), sutra);
  }

  YogaSutraModel? getSutra({required int chapterNo, required int sutraNo, String? lang}) {
    return _sutras[_uniqueSutraIdentifier(chapterNo: chapterNo, sutraNo: sutraNo, lang: lang)];
  }

  @override
  List<Object?> get props => [isLoading, error, yogaSutraInfo, _sutras];
}
