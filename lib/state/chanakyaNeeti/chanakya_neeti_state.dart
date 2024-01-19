part of 'chanakya_neeti_bloc.dart';

@immutable
class ChanakyaNeetiState extends Equatable {
  final bool isLoading;
  final String? error;
  final Map<int, ChanakyaNeetiChapterInfoModel> _chaptersInfo; //chapterNo,ChanakyaNeetiChapterInfoModel
  final Map<String, ChanakyaNeetiVerseModel> _verses; //id,ChanakyaNeetiVerseModel

  const ChanakyaNeetiState({
    this.isLoading = false,
    this.error,
    Map<int, ChanakyaNeetiChapterInfoModel> chaptersInfo = const {},
    Map<String, ChanakyaNeetiVerseModel> verses = const {},
  })  : _verses = verses,
        _chaptersInfo = chaptersInfo;

  ChanakyaNeetiState copyWith({
    bool? isLoading,
    String? error,
    Map<int, ChanakyaNeetiChapterInfoModel>? chaptersInfo,
    Map<String, ChanakyaNeetiVerseModel>? verses,
  }) {
    return ChanakyaNeetiState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      chaptersInfo: chaptersInfo ?? this._chaptersInfo,
      verses: verses ?? this._verses,
    );
  }

  factory ChanakyaNeetiState.initial() => const ChanakyaNeetiState();
  factory ChanakyaNeetiState.loading() => const ChanakyaNeetiState(isLoading: true);
  factory ChanakyaNeetiState.failure(String error) => ChanakyaNeetiState(error: error);
  factory ChanakyaNeetiState.success({
    required Map<int, ChanakyaNeetiChapterInfoModel> chaptersInfo,
    required Map<String, ChanakyaNeetiVerseModel> verses,
  }) =>
      ChanakyaNeetiState(
        chaptersInfo: chaptersInfo,
        verses: verses,
      );

  get allChaptersInfo => Map.unmodifiable(_chaptersInfo);
  void addChapterInfo(ChanakyaNeetiChapterInfoModel chapterInfo) {
    _chaptersInfo[chapterInfo.chapterNo] = chapterInfo;
  }

  get allVerses => Map.unmodifiable(_verses);
  void addVerse(ChanakyaNeetiVerseModel verse) {
    _verses[verse.id] = verse;
  }

  @override
  List<Object?> get props => [isLoading, error, _chaptersInfo, _verses];
}
