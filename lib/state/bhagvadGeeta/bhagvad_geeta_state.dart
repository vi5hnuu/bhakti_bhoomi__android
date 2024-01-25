part of 'bhagvad_geeta_bloc.dart';

@immutable
class BhagvadGeetaState extends Equatable {
  final bool isLoading;
  final String? error;
  final Map<String, BhagvadGeetaChapterModel> _bhagvadGeetaChapters; //bhagvadGeetaChapterId,bhagvadGeetaChapter
  final Map<String, BhagvadGeetaShlokModel> _bhagvadGeetaShloks; //bhagvadGeetaShlokId,bhagvadGeetaShlok

  const BhagvadGeetaState({this.isLoading = true, this.error, Map<String, BhagvadGeetaChapterModel> bhagvadGeetaChapters = const {}, Map<String, BhagvadGeetaShlokModel> bhagvadGeetaShloks = const {}})
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

  get bhagvadGeetaChapters => Map.unmodifiable(_bhagvadGeetaChapters);
  get bhagvadGeetaShloks => Map.unmodifiable(_bhagvadGeetaShloks);

  @override
  List<Object?> get props => [isLoading, error, _bhagvadGeetaChapters, _bhagvadGeetaShloks];
}
