part of 'chanakya_neeti_bloc.dart';

@immutable
class ChanakyaNeetiState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<ChanakyaNeetiChapterInfoModel>? _chaptersInfo; //ChanakyaNeetiChapterInfoModel
  final Map<String, ChanakyaNeetiVerseModel> _verses; //id,ChanakyaNeetiVerseModel

  const ChanakyaNeetiState({
    this.isLoading = true,
    this.error,
    List<ChanakyaNeetiChapterInfoModel>? chaptersInfo,
    Map<String, ChanakyaNeetiVerseModel> verses = const {},
  })  : _verses = verses,
        _chaptersInfo = chaptersInfo;

  ChanakyaNeetiState copyWith({
    bool? isLoading,
    String? error,
    List<ChanakyaNeetiChapterInfoModel>? chaptersInfo,
    Map<String, ChanakyaNeetiVerseModel>? verses,
  }) {
    return ChanakyaNeetiState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      chaptersInfo: chaptersInfo ?? this._chaptersInfo,
      verses: verses ?? this._verses,
    );
  }

  factory ChanakyaNeetiState.initial() => const ChanakyaNeetiState();

  List<ChanakyaNeetiChapterInfoModel>? get allChaptersInfo => _chaptersInfo != null ? List.unmodifiable(_chaptersInfo) : null;

  Map<String, ChanakyaNeetiVerseModel> get allVerses => Map.unmodifiable(_verses);

  String _uniqueKey({required int chapterNo, required int verseNo}) => '$chapterNo-$verseNo';

  MapEntry<String, ChanakyaNeetiVerseModel> getEntry(ChanakyaNeetiVerseModel verse) => MapEntry(_uniqueKey(chapterNo: verse.chapterNo, verseNo: verse.verseNo), verse);

  bool verseExists({required int chapterNo, required int verseNo}) => _verses.containsKey(_uniqueKey(chapterNo: chapterNo, verseNo: verseNo));

  ChanakyaNeetiVerseModel? getVerse({required int chapterNo, required int verseNo}) => _verses[_uniqueKey(chapterNo: chapterNo, verseNo: verseNo)];

  static String commentForId({required int chapterNo, required int verseNo}) {
    return 'chapterNo_$chapterNo-verseNo_$verseNo';
  }

  @override
  List<Object?> get props => [isLoading, error, _chaptersInfo, _verses];
}
