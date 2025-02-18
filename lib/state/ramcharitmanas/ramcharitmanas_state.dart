part of 'ramcharitmanas_bloc.dart';

@immutable
class RamcharitmanasState extends Equatable with WithHttpState {
  final RamcharitmanasInfoModel? info;
  final Map<String, RamcharitmanasMangalacharanModel> _mangalacharan; //kand, mangalacharan
  final Map<String, RamcharitmanasVerseModel> _verses; //_uniqueKey, verse
  static final String defaultLang = "dv";

  RamcharitmanasState({
    Map<String,HttpState>? httpStates,
    this.info,
    Map<String, RamcharitmanasMangalacharanModel> mangalacharan = const {},
    Map<String, RamcharitmanasVerseModel> verses = const {},
  })  : _verses = verses,
        _mangalacharan = mangalacharan{
    this.httpStates.addAll(httpStates ?? {});
  }

  RamcharitmanasState copyWith({
    Map<String, HttpState>? httpStates,
    RamcharitmanasInfoModel? info,
    Map<String, RamcharitmanasMangalacharanModel>? mangalacharan,
    Map<String, RamcharitmanasVerseModel>? verses,
  }) {
    return RamcharitmanasState(
      httpStates: httpStates ?? this.httpStates,
      info: info ?? this.info,
      mangalacharan: mangalacharan ?? this._mangalacharan,
      verses: verses ?? this._verses,
    );
  }

  factory RamcharitmanasState.initial() => RamcharitmanasState();

  Map<String, RamcharitmanasMangalacharanModel> get allMangalacharan => Map.unmodifiable(_mangalacharan);

  Map<String, RamcharitmanasVerseModel> get allVerses => Map.unmodifiable(_verses);

  String _uniqueVerseKey({required String kand, required int verseNo, String? lang}) => '$kand-$verseNo-${lang ?? defaultLang}';
  String _uniqueMangalacharanKey({required String kand, String? lang}) => '$kand-${lang ?? defaultLang}';

  bool verseExists({required String kand, required int verseNo, String? lang}) => _verses.containsKey(_uniqueVerseKey(kand: kand, verseNo: verseNo, lang: lang ?? defaultLang));

  bool mangalacharanExists({required String kand, String? lang}) => _mangalacharan.containsKey(_uniqueMangalacharanKey(kand: kand, lang: lang ?? defaultLang));

  RamcharitmanasVerseModel? getVerse({required String kand, required int verseNo, String? lang}) => _verses[_uniqueVerseKey(kand: kand, verseNo: verseNo, lang: lang ?? defaultLang)];

  static String commentForId({required String kand, int? verseNo, required String lang}) {
    return 'kand_$kand-${verseNo != null ? 'verseNo_$verseNo' : ''}-lang_${lang}';
  }

  RamcharitmanasMangalacharanModel? getMangalacharan({required String kand, String? lang}) => _mangalacharan[_uniqueMangalacharanKey(kand: kand, lang: lang ?? defaultLang)];

  MapEntry<String, RamcharitmanasVerseModel> getVerseEntry(RamcharitmanasVerseModel verse) => MapEntry(_uniqueVerseKey(kand: verse.kanda, verseNo: verse.versesNo, lang: verse.language), verse);

  MapEntry<String, RamcharitmanasMangalacharanModel> getMangalacharanEntry(RamcharitmanasMangalacharanModel mangalacharan) =>
      MapEntry(_uniqueMangalacharanKey(kand: mangalacharan.kanda, lang: mangalacharan.language), mangalacharan);
  int? totalVersesInKand(String kand) => info?.kandaInfo[kand];

  List<String> getAllKands() {
    final kands = info?.kandaMapping.entries.toList();
    kands?.sort((kandE1, kandE2) => kandE1.value - kandE2.value);
    return kands?.map((e) => e.key).toList() ?? [];
  }

  @override
  List<Object?> get props => [httpStates, info, _mangalacharan, _verses];
}
