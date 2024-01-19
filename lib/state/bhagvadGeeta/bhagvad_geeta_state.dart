part of 'bhagvad_geeta_bloc.dart';

@immutable
class BhagvadGeetaState extends Equatable {
  final bool isLoading;
  final String? error;
  final Map<String, BhagvadGeetaChapterModel> _bhagvadGeetaChapters; //bhagvadGeetaChapterId,bhagvadGeetaChapter
  final Map<String, BhagvadGeetaShlokModel> _bhagvadGeetaShloks; //bhagvadGeetaShlokId,bhagvadGeetaShloks

  const BhagvadGeetaState(
      {this.isLoading = false, this.error, Map<String, BhagvadGeetaChapterModel> bhagvadGeetaChapters = const {}, Map<String, BhagvadGeetaShlokModel> bhagvadGeetaShloks = const {}})
      : _bhagvadGeetaShloks = bhagvadGeetaShloks,
        _bhagvadGeetaChapters = bhagvadGeetaChapters;

  BhagvadGeetaState copyWith({
    bool? isLoading,
    String? error,
    Map<String, BhagvadGeetaChapterModel>? bhagvadGeetaChapters,
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
  factory BhagvadGeetaState.loading() => BhagvadGeetaState(isLoading: true);
  factory BhagvadGeetaState.failure(String error) => BhagvadGeetaState(error: error);
  factory BhagvadGeetaState.success(Map<String, BhagvadGeetaChapterModel> bhagvadGeetaChapters, Map<String, BhagvadGeetaShlokModel> bhagvadGeetaShloks) =>
      BhagvadGeetaState(bhagvadGeetaChapters: bhagvadGeetaChapters, bhagvadGeetaShloks: bhagvadGeetaShloks);

  get bhagvadGeetaChapters => Map.unmodifiable(_bhagvadGeetaChapters);
  void addBhagvadGeetaChapter(BhagvadGeetaChapterModel bhagvadGeetaChapter) {
    _bhagvadGeetaChapters[bhagvadGeetaChapter.id] = bhagvadGeetaChapter;
  }

  get bhagvadGeetaShloks => Map.unmodifiable(_bhagvadGeetaShloks);
  void addBhagvadGeetaShlok(BhagvadGeetaShlokModel bhagvadGeetaShlok) {
    _bhagvadGeetaShloks[bhagvadGeetaShlok.id] = bhagvadGeetaShlok;
  }

  @override
  List<Object?> get props => [isLoading, error, _bhagvadGeetaChapters, _bhagvadGeetaShloks];
}
