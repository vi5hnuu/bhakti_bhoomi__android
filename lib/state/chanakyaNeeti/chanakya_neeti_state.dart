part of 'chanakya_neeti_bloc.dart';

@immutable
class ChanakyaNeetiState extends Equatable {
  final bool isLoading;
  final String? error;
  final Map<int, ChanakyaNeetiChapterInfoModel> _chaptersInfo; //chapterNo,ChanakyaNeetiChapterInfoModel
  final Map<String, ChanakyaNeetiVerseModel> _verses; //id,ChanakyaNeetiVerseModel

  const ChanakyaNeetiState({
    this.isLoading = true,
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

  get allChaptersInfo => Map.unmodifiable(_chaptersInfo);

  get allVerses => Map.unmodifiable(_verses);

  @override
  List<Object?> get props => [isLoading, error, _chaptersInfo, _verses];
}
