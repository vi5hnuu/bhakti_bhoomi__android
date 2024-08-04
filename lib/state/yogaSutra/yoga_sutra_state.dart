part of 'yoga_sutra_bloc.dart';

@immutable
class YogaSutraState extends Equatable with WithHttpState {
  final YogaSutraInfoModel? yogaSutraInfo;
  final Map<String, YogaSutraModel> _sutras; //sutraId,sutra
  static final defaultLanguage = "dv";

  YogaSutraState({
    Map<String,HttpState>? httpStates,
    this.yogaSutraInfo,
    Map<String, YogaSutraModel> sutras = const {},
  }) : _sutras = sutras{
    this.httpStates.addAll(httpStates ?? {});
  }

  YogaSutraState copyWith({
    Map<String, HttpState>? httpStates,
    YogaSutraInfoModel? yogaSutraInfo,
    Map<String, YogaSutraModel>? sutras,
  }) {
    return YogaSutraState(
      httpStates: httpStates ?? this.httpStates,
      yogaSutraInfo: yogaSutraInfo ?? this.yogaSutraInfo,
      sutras: sutras ?? this._sutras,
    );
  }

  factory YogaSutraState.initial() => YogaSutraState();

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

  static String commentForId({required int chapterNo, required int sutraNo, required String lang}) {
    return 'chapterNo_$chapterNo-sutraNo_$sutraNo-lang_${lang}';
  }

  @override
  List<Object?> get props => [httpStates, yogaSutraInfo, _sutras];
}
