part of 'bhagvad_geeta_bloc.dart';

@immutable
class BhagvadGeetaState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<BhagvadGeetaChapterModel>? _bhagvadGeetaChapters; //bhagvadGeetaChapterId,bhagvadGeetaChapter
  final Map<String, BhagvadGeetaShlokModel> _bhagvadGeetaShloks; //bhagvadGeetaShlokId,bhagvadGeetaShlok

  const BhagvadGeetaState({this.isLoading = true, this.error, List<BhagvadGeetaChapterModel>? bhagvadGeetaChapters, Map<String, BhagvadGeetaShlokModel> bhagvadGeetaShloks = const {}})
      : _bhagvadGeetaShloks = bhagvadGeetaShloks,
        _bhagvadGeetaChapters = bhagvadGeetaChapters;

  BhagvadGeetaState copyWith({
    bool? isLoading,
    String? error,
    List<BhagvadGeetaChapterModel>? bhagvadGeetaChapters,
    Map<String, BhagvadGeetaShlokModel>? bhagvadGeetaShloks,
  }) {
    return BhagvadGeetaState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      bhagvadGeetaChapters: bhagvadGeetaChapters ?? this._bhagvadGeetaChapters,
      bhagvadGeetaShloks: bhagvadGeetaShloks ?? this._bhagvadGeetaShloks,
    );
  }

  factory BhagvadGeetaState.initial() => BhagvadGeetaState();

  String _uniqueKey({required int chapterNo, required int shlokNo}) => "$chapterNo-$shlokNo}";
  MapEntry<String, BhagvadGeetaShlokModel> getEntry(BhagvadGeetaShlokModel shlok) => MapEntry(_uniqueKey(chapterNo: shlok.chapter, shlokNo: shlok.verse), shlok);

  bool shlokExists({required int chapterNo, required int shlokNo}) => _bhagvadGeetaShloks.containsKey(_uniqueKey(chapterNo: chapterNo, shlokNo: shlokNo));

  List<BhagvadGeetaChapterModel>? get bhagvadGeetaChapters => _bhagvadGeetaChapters != null ? List.unmodifiable(_bhagvadGeetaChapters) : null;
  Map<String, BhagvadGeetaShlokModel> get bhagvadGeetaShloks => Map.unmodifiable(_bhagvadGeetaShloks);

  BhagvadGeetaShlokModel? getShlok({required int chapterNo, required int shlokNo}) => _bhagvadGeetaShloks[_uniqueKey(chapterNo: chapterNo, shlokNo: shlokNo)];

  @override
  List<Object?> get props => [isLoading, error, _bhagvadGeetaChapters, _bhagvadGeetaShloks];
}
